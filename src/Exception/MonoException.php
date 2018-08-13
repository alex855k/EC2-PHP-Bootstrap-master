<?php

namespace App\Exception;


/**
 * Define a custom TestException class
 */
class MonoException extends \Exception
{
    public function __construct($message, $code = 400, Exception $previous = null) {
        parent::__construct($message, $code, $previous);
    }


    public function __toString() {
        return __CLASS__ . ": [{$this->code}]: {$this->message}\n";
    }
}

