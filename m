From: loody <miloody-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Tue, 8 Jul 2014 00:13:08 +0800
Message-ID: <CANudz+vS1t3wWbEU6UGGKP=bb3KEvFcpmX=M2+ZnC8bxY_tPjQ@mail.gmail.com>
References: <CANudz+uUuhLdfkVSseXXHW6ugm126Q4Taau+s7wavAP=Z9=4XA@mail.gmail.com>
	<Pine.LNX.4.44L0.1407071147130.871-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1407071147130.871-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

hi Alan:

>> > E.g. issue an sg_read for one sector to the device every 4m:
>> >
>> >   */4 * * * * sg_read count=1 if=/dev/<disk>
>> Since my target platform arm embedded system,
>> does that mean I should include sg_read in my Busybox
>> or
>> cross-compile sg_read from sg3_utils?
>
> An alternative is to write a positive value, such as 240000, to
>
>         /sys/block/sdX/events_poll_msecs
>
> where X is replaced with the proper drive letter.  (240000 ms = 240 s =
> 4 m.)  I'm not sure this will work, but it's worth a try.

I cannot find events_poll_msecs you mentioned in my system.
Is this capability related to kernel version?
( my kernel version is 2.6.38.8 )

Sincerely appreciate all yours kind help,

PS:
below is result of /sys/block/sdb/
/sys/block/sdb# ls -lht
total 0
-r--r--r-- 1 root root 4.0K 2014-07-08 00:08 alignment_offset
lrwxrwxrwx 1 root root    0 2014-07-08 00:08 bdi ->
../../../../../../../../../../virtual/bdi/8:16
-r--r--r-- 1 root root 4.0K 2014-07-08 00:08 capability
-r--r--r-- 1 root root 4.0K 2014-07-08 00:08 dev
lrwxrwxrwx 1 root root    0 2014-07-08 00:08 device -> ../../../3:0:0:0
-r--r--r-- 1 root root 4.0K 2014-07-08 00:08 discard_alignment
-r--r--r-- 1 root root 4.0K 2014-07-08 00:08 ext_range
-r--r--r-- 1 root root 4.0K 2014-07-08 00:08 inflight
drwxr-xr-x 2 root root    0 2014-07-08 00:08 power
-r--r--r-- 1 root root 4.0K 2014-07-08 00:08 stat
drwxr-xr-x 2 root root    0 2014-07-08 00:08 trace
drwxr-xr-x 2 root root    0 2014-07-08 00:05 holders
drwxr-xr-x 3 root root    0 2014-07-08 00:05 queue
-r--r--r-- 1 root root 4.0K 2014-07-08 00:05 range
-r--r--r-- 1 root root 4.0K 2014-07-08 00:05 ro
drwxr-xr-x 5 root root    0 2014-07-08 00:05 sdb1
-r--r--r-- 1 root root 4.0K 2014-07-08 00:05 size
drwxr-xr-x 2 root root    0 2014-07-08 00:05 slaves
-r--r--r-- 1 root root 4.0K 2014-07-08 00:05 removable
lrwxrwxrwx 1 root root    0 2014-07-08 00:05 subsystem ->
../../../../../../../../../../../class/block
-rw-r--r-- 1 root root 4.0K 2014-07-08 00:05 uevent
/sys/block/sdb#
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
