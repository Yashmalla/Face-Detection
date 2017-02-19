 <?php

      $data = $_POST['names'];
      $N = (int)$data;

      
      $output = shell_exec('C:/"Program Files"/R/R-3.3.1/bin/Rscript.exe C:/xampp/htdocs/Face_detection/convolutional_nn_tutorial_3.R "'.$N.'" ' );
      $r = explode(" ", $output);
      $result = (int)$r[1];
      
      switch($result) {
          case 1:
            echo("./faces/burris.jpg");
            
            break;
          case 7:
            echo("./faces/7.jpg");
            
            break;
          case 13: 
              echo("./faces/13.png");
            break;
      }
   
    ?>