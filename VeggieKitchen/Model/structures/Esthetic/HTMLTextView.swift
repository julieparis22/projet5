//
//  HTMLTextView.swift
//  VeggieKitchen
//
//  Created by julie ryan on 05/08/2024.
//

import SwiftUI
import WebKit

struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String
    @Binding var dynamicHeight: CGFloat

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        // Add JavaScript message handler
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "heightHandler")
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let wrappedHtmlContent = wrapHtmlContent(htmlContent)
        uiView.loadHTMLString(wrappedHtmlContent, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func wrapHtmlContent(_ content: String) -> String {
        """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        body {
            font-size: 16px;
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            line-height: 1.5;
            padding: 0;
            margin: 0;
        }
        </style>
        </head>
        <body>
        \(content)
        <script>
        window.onload = function() {
            window.webkit.messageHandlers.heightHandler.postMessage(document.body.scrollHeight);
        }
        </script>
        </body>
        </html>
        """
    }
}

class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    var parent: HTMLTextView

    init(_ parent: HTMLTextView) {
        self.parent = parent
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState") { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight") { (height, error) in
                    if let height = height as? CGFloat {
                        DispatchQueue.main.async {
                            self.parent.dynamicHeight = height
                        }
                    }
                }
            }
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "heightHandler", let height = message.body as? CGFloat {
            DispatchQueue.main.async {
                self.parent.dynamicHeight = height
            }
        }
    }
}
