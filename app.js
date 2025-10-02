const http = require('http');

// Define the port from environment variable or default to 8000
const PORT = process.env.PORT || 8000;

// Create HTTP server
const server = http.createServer((req, res) => {
    // Health check route
    if (req.url === '/health') {
        res.writeHead(200, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({ status: 'OK' }));
    } else {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.end('Hello World!');
    }
});

// Handle errors
server.on('error', (err) => {
    console.error('Error occurred: ', err);
});

// Start the server
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
