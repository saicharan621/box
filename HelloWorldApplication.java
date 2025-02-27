package com.example;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class HelloWorldApplication {

    public static void main(String[] args) {
        SpringApplication.run(HelloWorldApplication.class, args);
    }
}

@RestController
@RequestMapping("/api")
class HelloWorldController {

    private static final Logger logger = LoggerFactory.getLogger(HelloWorldController.class);

    @GetMapping("/hello")
    public ResponseEntity<String> sayHello() {
        logger.info("Received request to /api/hello");
        String message = "Hello, World! The application is running successfully.";
        return new ResponseEntity<>(message, HttpStatus.OK);
    }

    @GetMapping("/error")
    public ResponseEntity<String> generateError() {
        logger.error("Generating a test error.");
        try {
            int result = 10 / 0; // Simulate an error
            return new ResponseEntity<>("Result: " + result, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Error occurred: {}", e.getMessage());
            return new ResponseEntity<>("An error occurred.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}