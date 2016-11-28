//
//  AVDownloadSessionDelegate.swift
//  Alamofire
//
//  Created by Daniel Morrow on 11/26/16.
//  Copyright © 2016 Alamofire. All rights reserved.
//

import AVFoundation

@available(iOSApplicationExtension 9.0, *)
class AVDownloadSessionDelegate: SessionDelegate {

    // MARK: AVAssetDownloadDelegate Overrides
    
    /// Overrides default behavior for AVAssetDownloadDelegate method `urlSession(_:assetDownloadTask:location:)`.
    open var avSessionDownloadTaskDidFinishLoadingTo: ((URLSession, AVAssetDownloadTask, URL) -> Void)?
    
    /// Overrides default behavior for AVAssetDownloadDelegate method `urlSession(_:assetDownloadTask:didLoad:totalTimeRangesLoaded:timeRangeExpectedToLoad:)`.
    open var avSessionDownloadDidLoadRanges: ((URLSession, AVAssetDownloadTask, CMTimeRange, [NSValue], CMTimeRange) -> Void)?
    
    /// Overrides default behavior for AVAssetDownloadDelegate method `urlSession(_:assetDownloadTask:didResolve:)`.
    open var avSessionDownloadDidResolve: ((URLSession, AVAssetDownloadTask, AVMediaSelection) -> Void)?
    
}

@available(iOSApplicationExtension 9.0, *)
extension AVDownloadSessionDelegate : AVAssetDownloadDelegate {
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        if let avSessionDownloadTaskDidFinishLoadingTo = avSessionDownloadTaskDidFinishLoadingTo {
            avSessionDownloadTaskDidFinishLoadingTo(session, assetDownloadTask, location)
        } else if let delegate = self[assetDownloadTask]?.delegate as? AVAssetDownloadTaskDelegate {
            delegate.urlSession(session, assetDownloadTask: assetDownloadTask, didFinishDownloadingTo: location)
        }

    }
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        if let avSessionDownloadDidLoadRanges = avSessionDownloadDidLoadRanges {
            avSessionDownloadDidLoadRanges(session, assetDownloadTask, timeRange, loadedTimeRanges, timeRangeExpectedToLoad)
        } else if let delegate = self[assetDownloadTask]?.delegate as? AVAssetDownloadTaskDelegate {
            delegate.urlSession(session, assetDownloadTask: assetDownloadTask, didLoad: timeRange, totalTimeRangesLoaded: loadedTimeRanges, timeRangeExpectedToLoad: timeRangeExpectedToLoad)
        }
    }
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didResolve resolvedMediaSelection: AVMediaSelection) {
        if let avSessionDownloadDidResolve = avSessionDownloadDidResolve {
            avSessionDownloadDidResolve(session, assetDownloadTask, resolvedMediaSelection)
        } else if let delegate = self[assetDownloadTask]?.delegate as? AVAssetDownloadTaskDelegate {
            delegate.urlSession(session, assetDownloadTask: assetDownloadTask, didResolve: resolvedMediaSelection)
        }
    }
}
