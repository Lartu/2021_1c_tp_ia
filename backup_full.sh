#!/usr/bin/env bash

#  ___          _             ___     _ _ 
# | _ ) __ _ __| |___  _ _ __| __|  _| | |
# | _ \/ _` / _| / / || | '_ \ _| || | | |
# |___/\__,_\__|_\_\\_,_| .__/_| \_,_|_|_|
#                       |_|               

# Este archivo está croneado con cron todos los días a las 0 horas y los
# domingos a las 23 horas.

function log ()
{   
    MINSEC=`date '+%H:%M:%S'`
    echo "$MINSEC - $1"
    echo "$MINSEC - $1" >> backup_log.log
}

function cleanexit()
{
    rm -r backup_log.log
    exit $1
}

ORIGIN=$1
DEST=$2

# Comando -h
if [[ $* == "-h" ]]; then
    echo ""
    echo "BackupFull"
    echo "Usage:"
    echo -e "\tbackup_full <source directory> <destination directory>"
    echo -e "\tbackup_full -h"
    echo ""
    echo "Options:"
    echo -e "\t-h\t\tDisplays this help stub."
    cleanexit 0
    echo ""
fi

# Validaciones directorio origen
log "Checkeando directorio de origen."
if [ -z "$ORIGIN" ]; then
    echo "No se ha suministrado el directorio de origen."
    cleanexit 1
fi
if [ ! -d "$ORIGIN" ]; then
    echo "El directorio de origen $ORIGIN no está disponible."
    cleanexit 1
fi

# Validaciones directorio destino
log "Checkeando directorio de destino."
if [ -z "$DEST" ]; then
    echo "No se ha suministrado el directorio de destino."
    cleanexit 2
fi
if [ ! -d "$DEST" ]; then
    echo "El directorio de destino $DEST no está disponible."
    cleanexit 1
fi

log "Obteniendo fecha."
ANSIDATE=`date '+%Y%m%d'`

log "Obteniendo generando filename."
FILENAME="`echo $ORIGIN | sed 's/\///'`_bkp_$ANSIDATE.tar.gz"
FILENAME="$DEST/$FILENAME"
log "Filename generado: $FILENAME"

log "Comprimiendo $ORIGIN a $FILENAME"
tar -czvf "$FILENAME" "$ORIGIN"

log "Proceso completo."
cat backup_log.log | mail -s "Resultados backup $ANSIDATE" root

cleanexit 0