//
//  MusicListModel.swift
//  MusicApp
//
//  Created by Sachin Gupta on 3/10/21.
//

import Foundation
struct MusicModel {
    var songTrackUrl:String?
    var title:String?
    var artist:String?
    var thubnailUrl:String?
    var imageUrl:String?
    var previewUrl:String?
}

class MusicFeedParser: NSObject {
    var nodeValue:String = ""
    var currentMusicModel:MusicModel?
    var musicListModel = [MusicModel]()
    var xmlData:Data
    var attribute = [String : [String : String]?]()
    var completion:(_ musicListModel:[MusicModel])->Void
    init(xmlData:Data, completion:@escaping (_ musicListModel:[MusicModel])->Void) {
        self.completion = completion
        self.xmlData = xmlData
    }
    func parse() {
            let xmlParser = XMLParser(data: xmlData)
            xmlParser.delegate = self
            xmlParser.parse()
    }
}

extension MusicFeedParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        nodeValue = ""
        if elementName == "entry" {
            currentMusicModel = MusicModel()
        }
        self.attribute[elementName] = attributeDict
        
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let elementValue = nodeValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if elementName == "id" {
            currentMusicModel?.songTrackUrl = elementValue
        } else if elementName == "title" {
            currentMusicModel?.title = elementValue
        } else if elementName == "im:artist" {
            currentMusicModel?.artist = elementValue
        } else if elementName == "im:image" {
            if let attributeDict = self.attribute[elementName] {
                if let height = attributeDict?["height"] {
                    switch height {
                    case "55":
                        currentMusicModel?.thubnailUrl = elementValue
                    case "170":
                        currentMusicModel?.imageUrl = elementValue
                    default:
                        break
                    }
                }
            }
        } else if elementName == "link" {
            if let attributeDict = self.attribute[elementName] {
                if let title = attributeDict?["title"], let url = attributeDict?["href"] {
                    if title.lowercased() == "preview" {
                        currentMusicModel?.previewUrl = url
                    }
                }
            }
        }
        else if elementName == "entry" {
            if let currentMusicModel = currentMusicModel {
                musicListModel.append(currentMusicModel)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        nodeValue += string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion(musicListModel)
    }
}
