import android.content.Intent;
import android.content.ActivityNotFoundException;
import android.net.Uri;
import android.os.Build;
import android.webkit.WebView;
import android.webkit.WebResourceRequest;
import android.webkit.WebViewClient;
import android.widget.Toast;

import org.apache.cordova.*;
import org.apache.cordova.engine.SystemWebView;

/**
 * Cordova plugin that intercepts UPI deep links inside the WebView
 * and launches the respective native UPI apps if installed.
 * 
 * This version wraps the original Cordova WebViewClient so that
 * other Cordova plugins continue to work correctly.
 */
public class UPILinkPlugin extends CordovaPlugin {

    @Override
    public void pluginInitialize() {
        final CordovaWebView webView = this.webView;
        final CordovaInterface cordova = this.cordova;

        if (webView.getView() instanceof SystemWebView) {
            SystemWebView sysWebView = (SystemWebView) webView.getView();

            // Save original Cordova WebViewClient
            WebViewClient originalClient = sysWebView.getWebViewClient();

            // Wrap it with our UPI interceptor
            sysWebView.setWebViewClient(new CustomWebViewClient(cordova, originalClient));
        }
    }

    private static class CustomWebViewClient extends WebViewClient {
        private final CordovaInterface cordova;
        private final WebViewClient originalClient;

        public CustomWebViewClient(CordovaInterface cordova, WebViewClient originalClient) {
            this.cordova = cordova;
            this.originalClient = originalClient;
        }

        // For older Android versions
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            if (handleUPILink(url)) return true;
            return originalClient != null && originalClient.shouldOverrideUrlLoading(view, url);
        }

        // For Lollipop (API 21+) and above
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            String url = request.getUrl().toString();
            if (handleUPILink(url)) return true;
            return originalClient != null && originalClient.shouldOverrideUrlLoading(view, request);
        }

        /**
         * Detects UPI deep links and opens the corresponding native app.
         */
        private boolean handleUPILink(String url) {
            if (url == null) return false;

            if (url.startsWith("upi://") ||
                url.startsWith("phonepe://") ||
                url.startsWith("paytmmp://") ||
                url.startsWith("tez://") ||
                url.startsWith("gpay://") ||
                url.startsWith("bhim://") ||
                url.startsWith("amazonpay://") ||
                url.startsWith("mobikwik://") ||
                url.startsWith("freecharge://") ||
                url.startsWith("truecaller://upi") ||
                url.startsWith("whatsapp://upi")) {

                try {
                    Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                    cordova.getActivity().startActivity(intent);
                    return true; // handled
                } catch (ActivityNotFoundException e) {
                    Toast.makeText(cordova.getActivity(),
                            "No UPI supported application found",
                            Toast.LENGTH_LONG).show();
                    return true;
                }
            }

            return false; // not a UPI link
        }
    }
}
