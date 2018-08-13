<?php

namespace App\Controller;

use App\Utils\ApiResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class HealthController extends Controller
{
    /**
     * @Route("/health", name="health")
     */
    public function check()
    {
        $data = [
            'time' => \Carbon\Carbon::now()
        ];

        return new ApiResponse($data);
    }
}
