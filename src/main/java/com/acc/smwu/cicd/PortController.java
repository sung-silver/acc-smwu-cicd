package com.acc.smwu.cicd;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PortController {

    @GetMapping("/port")
    public String getPort(HttpServletRequest request) {
        return "Running on port: " + request.getLocalPort();
    }
}
