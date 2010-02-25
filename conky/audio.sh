reszta=$(expr 100 \* $(aumix -q |grep vol |awk '{print $3}'))
if [ $reszta = 100 ]
then
  echo 1.00
elif [ $reszta -lt 10 ]
then
  echo 0.0$reszta
else
  echo 0.$reszta
fi
