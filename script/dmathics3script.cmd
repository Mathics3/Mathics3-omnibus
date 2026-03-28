rem Simple Powershell command file to run mathicsscript
rem add features of bash script
docker run --name mathics3-cli --rm --tty --interactive --network=host mathicsorg/mathics:latest --mode cli
