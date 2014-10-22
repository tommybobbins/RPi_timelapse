#! /bin/sh

### BEGIN INIT INFO
# Provides:		tlcam
# Required-Start:	$syslog
# Required-Stop:	$syslog
# Default-Start:	2 3 4 5
# Default-Stop:		0 1 6
# Short-Description:	Time-lapse camera
### END INIT INFO

DATADIR=/var/tlcam
SERIES=$DATADIR/series

set -e

# /etc/init.d/tlcam.sh: start and stop the time-lapse camera

test -x /usr/local/bin/tlcam || exit 0
test -x $DATADIR || exit 0

umask 022

. /lib/lsb/init-functions

increment_series_number() {
    if test -f $SERIES; then
        SERNUM=$(( $(cat $SERIES) + 1 ))
        echo $SERNUM >| $SERIES
    else    
        echo "1" > $SERIES
    fi
}

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin:/usr/local/bin"

case "$1" in
  start)
	log_daemon_msg "Starting time-lapse camera" "tlcam" || true
	if start-stop-daemon --start --quiet --oknodo --pidfile /var/run/tlcam.pid --background --make-pidfile --exec /usr/local/bin/tlcam; then
            increment_series_number
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;
  stop)
	log_daemon_msg "Stopping time-lapse camera" "tlcam" || true
	if start-stop-daemon --stop --quiet --oknodo --pidfile /var/run/tlcam.pid; then
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;

  restart)
	log_daemon_msg "Restarting time-lapse camera" "tlcam" || true
	start-stop-daemon --stop --quiet --oknodo --retry 30 --pidfile /var/run/tlcam.pid
	if start-stop-daemon --start --quiet --oknodo --pidfile /var/run/tlcam.pid --make-pidfile --background --exec /usr/local/bin/tlcam ; then
            increment_series_number
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;

  status)
	status_of_proc -p /var/run/tlcam.pid /usr/local/bin/tlcam tlcam && exit 0 || exit $?
	;;

  *)
	log_action_msg "Usage: /etc/init.d/tlcam {start|stop|restart|status}" || true
	exit 1
esac

exit 0
