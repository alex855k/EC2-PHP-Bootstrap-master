<?php

namespace App\Controller;

use App\Utils\ApiResponse;
use App\Exception\TestException;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class TestController extends Controller
{
    public function index()
    {
        $data = [
            'bool' => true,
            'message' => 'Test endpoint',
        ];

        return new ApiResponse($data);
    }

    public function hello($name)
    {
        $data = [
            'hello' => $name,
        ];

        return new ApiResponse($data, JsonResponse::HTTP_I_AM_A_TEAPOT);
    }

    public function error()
    {
        try {
            throw new TestException();

        } catch (\Exception $e) {
            return new ApiResponse($e);
        }
    }
}
