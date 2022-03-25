vcl 4.0;

import directors;
import std;


backend site1 {
        .host = "imaginary-service";
        .port = "9000";

}


sub vcl_recv {

        set req.backend_hint = site1;

}
