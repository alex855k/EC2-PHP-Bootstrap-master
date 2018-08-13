<?php

namespace App\Exception;


/**
 * Define a custom TestException class
 */
class TestException extends MonoException
{
    const CODE = 400;
    
    public function __construct($message = "Test Exception") {
        parent::__construct($message, self::CODE);
    }
}

