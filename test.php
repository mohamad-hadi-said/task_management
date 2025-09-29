<?php

function plas($a)
{
    return fn($b) => $a + $b;
}


echo plas(5)(10);