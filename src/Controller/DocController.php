<?php

namespace App\Controller;

use Swagger\Annotations as SWG;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class DocController extends Controller
{
    /**
     * @Route("/doc", name="doc")
     *
     * @SWG\Swagger(
     *     schemes={"http","https"},
     *     host="api.host.com",
     *     basePath="/",
     *     @SWG\Info(
     *         version="1.0.0",
     *         title="Bootstrap documenation",
     *         description="Api description...",
     *         termsOfService="",
     *         @SWG\Contact(
     *             email="noreply@monosolutions.com"
     *         ),
     *         @SWG\License(
     *             name="Private License",
     *             url="https://www.monosolutions.com/end-user-license-agreement"
     *         )
     *     )
     * )
     * @SWG\Get(
     *     path="/doc",
     *     tags={"default"},
     *     @SWG\Response(
     *          response="200",
     *          description="The documentation",
     *     )
     * )
     *
     */
    public function index()
    {
        $swagger = \Swagger\scan($this->get('kernel')->getRootDir());

        return new JsonResponse($swagger);
    }
}
