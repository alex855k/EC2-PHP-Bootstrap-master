<?

namespace App\Utils;

use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

class ApiResponse extends JsonResponse
{
    /**
     * @param mixed $data    The response data
     * @param int   $status  The response status code
     * @param array $headers An array of response headers
     */
    public function __construct($data = [], $code = 200, array $headers = [])
    {
        $data = $this->build($data, $code);

        parent::__construct($data, $this->code, $headers, false);
    }
    /**
     * Build the API response based on content and status code
     *
     * @param mixed $data
     * @param int $code
     * @return void
     */
    private function build($data, $code) 
    {
        $this->code = intval($code);
        $result = [];

        if ($data instanceof \Exception) {
            $this->code = $data->getCode();
            $result = [
                'success' => false,
                'code'    => $data->getCode(),
                'error'   => $data->getMessage()
            ];
        } else {
            $result = [
                'success' => true,
                'code'    => $code,
                'data'    => $data
            ];
        }

        return $result;
    }
}