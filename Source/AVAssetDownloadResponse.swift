//
//  AVAssetDownloadResponse.swift
//  Alamofire
//
//  Created by Dan Morrow on 12/1/16.
//  Copyright © 2016 Alamofire. All rights reserved.
//

import UIKit
import AVFoundation

/// Used to store all data associated with a response of a avAssetDownload request.
@available(iOSApplicationExtension 9.0, *)
public struct AVAssetDownloadResponse {
    /// The AVURLAsset that we began with.
    public let avURLAsset: AVURLAsset?
    
    /// The resolved media selection
    public let resolvedMediaSelection: AVMediaSelection?
    
    /// The error encountered while executing or validating the request.
    public let error: Error?
    
    /// The timeline of the complete lifecycle of the request.
    public let timeline: Timeline
    
    var _metrics: AnyObject?
    
    init(avURLAsset: AVURLAsset?, resolvedMediaSelection: AVMediaSelection?, error: Error?, timeline: Timeline = Timeline()) {
        self.avURLAsset = avURLAsset
        self.resolvedMediaSelection = resolvedMediaSelection
        self.error = error
        self.timeline = timeline
    }

}
// MARK: -

@available(iOSApplicationExtension 9.0, *)
extension AVAssetDownloadResponse: CustomStringConvertible, CustomDebugStringConvertible {
    /// The textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure.
    public var description: String {
        return avURLAsset.debugDescription
    }
    
    /// The debug textual representation used when written to an output stream, which includes the URL request, the URL
    /// response, the server data, the response serialization result and the timeline.
    public var debugDescription: String {
        var output: [String] = []
        
        output.append(avURLAsset != nil ? "[AVURLAsset]: \(avURLAsset!)" : "[AVURLAsset]: nil")
        output.append(resolvedMediaSelection != nil ? "[AVMediaSelection]: \(resolvedMediaSelection!)" : "[AVMediaSelection]: nil")
        output.append("[Timeline]: \(timeline.debugDescription)")
        
        return output.joined(separator: "\n")
    }
}

@available(iOS 10.0, *)
extension AVAssetDownloadResponse : Response {
    #if !os(watchOS)
    /// The task metrics containing the request / response statistics.
    public var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
    #endif
}


@available(iOSApplicationExtension 9.0, *)
extension AVAssetDownloadRequest {
    /// Adds a handler to be called once the request has finished.
    ///
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter completionHandler: The code to be executed once the request has finished.
    ///
    /// - returns: The request.
    @discardableResult
    public func response(queue: DispatchQueue? = nil, completionHandler: @escaping (AVAssetDownloadResponse) -> Void) -> Self {
        delegate.queue.addOperation {
            (queue ?? DispatchQueue.main).async {
                var avAssetResponse = AVAssetDownloadResponse(
                    avURLAsset: self.avAsset,
                    resolvedMediaSelection: self.avAssetDownloadDelegate.resolvedMediaSelection,
                    error: self.delegate.error,
                    timeline: self.timeline
                )
                
                avAssetResponse.add(self.delegate.metrics)
                
                completionHandler(avAssetResponse)
            }
        }
        
        return self
    }
}

