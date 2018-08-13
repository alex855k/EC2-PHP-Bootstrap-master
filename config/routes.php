<?php

namespace App;

use App\Controller\TestController;
use App\Controller\HealthController;

use Symfony\Component\Routing\Route;
use Symfony\Component\Routing\RouteCollection;

$collection = new RouteCollection();


$collection->add('health_check', new Route('/health', [
    '_controller' => [HealthController::class, 'check']
], [], [], '', [], ['GET']));

$collection->add('test_index', new Route('/test', [
    '_controller' => [TestController::class, 'index']
], [], [], '', [], ['GET']));

$collection->add('test_name', new Route('/test/name/{name}', [
    '_controller' => [TestController::class, 'hello']
], [], [], '', [], ['GET']));

$collection->add('test_error', new Route('/test/error', [
    '_controller' => [TestController::class, 'error']
], [], [], '', [], ['GET']));

return $collection;
