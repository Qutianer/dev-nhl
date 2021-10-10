<?php
echo gethostname();
exec("stress-ng --cpu 8 --io 4 --vm 4 --vm-bytes 256M --fork 4 --timeout 100s");
?>
