#!/bin/bash
# Variabili di configurazione

LOGDESTINATIONS="CFS"
LOGFOLDER="/usr/local/obassets/logs/diskspace/"
LOGEMAILS="serverlog@gmail.com"
LOGFILEPREFIX="check_disk_space"
LOGMAILSUBJECT="[WARNING] Attenzione! Disco sovrautilizzato su su ${HOSTNAME}"

LOGFILENAME=$LOGFILEPREFIX"@"$(date "+%Y-%m-%d-%H-%M-%S")".log"

# LOGFOLDER="/tmp/backuplog-test/"
# LOGEMAILS="a.badii@open-box.it"

# Logger
logMessage()
{
  # Controlla se inserire il timestamp nel messaggio di log
  if [ "$2" = "NT" ]; then
    MESSAGE=$1
  else
    MESSAGE=$(date "+%Y-%m-%d %H:%M:%S")" - $1"
  fi

  # Controlla a quali destinazioni inviare il messaggio di log
  # in base al valore della variabile LOGDESTINATIONS
  # C = Console
  # F = File
  # S = Syslog

  if [[ "$LOGDESTINATIONS" =~ "C" ]]
  then
    echo $MESSAGE
  fi

  if [[ "$LOGDESTINATIONS" =~ "F" ]]
  then
    echo $MESSAGE >> $LOGFOLDER$LOGFILENAME
  fi

  if [[ "$LOGDESTINATIONS" =~ "S" ]]
  then
    logger -i -t -- $LOGFILEPREFIX" - "$MESSAGE
  fi
}

# Invia email con allegato
sendMail()
{

  for DESTEMAIL in $LOGEMAILS
  do
    mail -a"from:${HOSTNAME}@open-box.it" -s "$LOGMAILSUBJECT" "$DESTEMAIL" < "$LOGFOLDER$LOGFILENAME"
  #  mail -s "$LOGMAILSUBJECT" "$DESTEMAIL" < "$LOGFOLDER$LOGFILENAME"
  done
}

# #controlla le partizioni

doLocalCheck()
{
  #df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{if (NR!=1) {print $5 " " $6} }' | while read output;
  df -H | grep -vE '^Filesystem|File system|tmpfs|cdrom' | awk '{print $5 " " $6}' | while read output;
  do
     #logMessage $output
     usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
     partition=$(echo $output | awk '{ print $2 }' )

      logMessage "${partition}: ${usep}%" NT
      if [[ $usep > 85 ]]; then
	  logMessage "Alert: Almost out of disk space $usep% on $partition" NT
	  sendMail
  #       echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
  #       mail -s "Alert: Almost out of disk space $usep%" you@somewhere.com
      fi

  done

}

# Routine principale
main()
{
  if [ ! -d $LOGFOLDER ]; then
    mkdir -p $LOGFOLDER
  fi

  logMessage '----------------------------------------------------' NT
  logMessage 'Check disk space started'
  logMessage '----------------------------------------------------' NT
  logMessage "" NT
  logMessage "Log file: $LOGFOLDER$LOGFILENAME" NT
  logMessage '----------------------------------------------------' NT
  doLocalCheck
  logMessage '----------------------------------------------------' NT
  logMessage "Check disk space  terminated succesfully" T
  logMessage '----------------------------------------------------' NT
}

# Fa partire la routine principale
main
