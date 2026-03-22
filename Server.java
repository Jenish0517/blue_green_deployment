import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.net.InetSocketAddress;

public class Server {
    public static void main(String[] args) throws IOException {
        // Support both -D property and Environment Variable
        String portStr = System.getProperty("server.port", System.getenv("SERVER_PORT"));
        if (portStr == null) portStr = "8080";
        int port = Integer.parseInt(portStr);

        String staticDir = System.getProperty("static.dir", System.getenv("STATIC_DIR"));
        if (staticDir == null) staticDir = "blue";
        
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/", new StaticHandler(staticDir));
        server.setExecutor(null);
        System.out.println("Server started on port " + port + " serving from " + staticDir);
        server.start();
    }

    static class StaticHandler implements HttpHandler {
        private final String staticDir;
        public StaticHandler(String staticDir) { this.staticDir = staticDir; }

        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String path = exchange.getRequestURI().getPath();
            if (path.equals("/")) path = "/index.html";
            
            Path filePath = Paths.get(staticDir, path.substring(1));
            if (Files.exists(filePath) && !Files.isDirectory(filePath)) {
                byte[] content = Files.readAllBytes(filePath);
                exchange.getResponseHeaders().set("Content-Type", getContentType(path));
                exchange.sendResponseHeaders(200, content.length);
                try (OutputStream os = exchange.getResponseBody()) { os.write(content); }
            } else {
                String res = "404 Not Found";
                exchange.sendResponseHeaders(404, res.length());
                try (OutputStream os = exchange.getResponseBody()) { os.write(res.getBytes()); }
            }
        }

        private String getContentType(String path) {
            if (path.endsWith(".html")) return "text/html";
            if (path.endsWith(".css")) return "text/css";
            if (path.endsWith(".js")) return "text/javascript";
            return "text/plain";
        }
    }
}
