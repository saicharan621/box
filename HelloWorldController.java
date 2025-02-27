package com.example.hellogame;

import org.springframework.web.bind.annotation.*;

import java.util.Random;

@RestController
@RequestMapping("/game")
public class HelloWorldController {
    
    private final int targetNumber = new Random().nextInt(100) + 1;

    @GetMapping("/guess/{number}")
    public String guessNumber(@PathVariable int number) {
        if (number < targetNumber) {
            return "Too low! Try again.";
        } else if (number > targetNumber) {
            return "Too high! Try again.";
        } else {
            return "Congratulations! You guessed the right number!";
        }
    }

    @GetMapping("/hint")
    public String getHint() {
        return "The number is between 1 and 100.";
    }
}
