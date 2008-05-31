From: devzero@web.de
Subject: (mptbase) Possible incompatibility between SATA and SAS
Date: Sat, 31 May 2008 11:14:07 +0200
Message-ID: <299006126@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:42084 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYEaJOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 May 2008 05:14:09 -0400
Received: from web.de
	by fmmailgate04.web.de (Postfix) with SMTP id A862D5ADC783
	for <linux-scsi@vger.kernel.org>; Sat, 31 May 2008 11:14:08 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-> http://bugzilla.kernel.org/show_bug.cgi?id=3D10413

maybe someone has a clue ?

i would not mix sata/sas in a raid array, but i`m not sure if that`s th=
e reason here.




Description From Arthur 2008-04-07 04:31 [reply]

Latest working kernel version:
Earliest failing kernel version:
Distribution: Debian Lenny
Hardware Environment: ASUS P5BV/SAS, Kingston 4GB (2x2) DDRAM 677Mhz, 5=
 Seagate
SATA x1Tb each
Software Environment: mdadm
Problem Description:I have 4 disks connected to SATA, one to SAS. All o=
f them
are merged to raid5 array using mdadm.

The server reboots automatically from time to time, the last reboot was=
 during
the scheduled array check. Nothing strange, except this message: mptbas=
e: ioc0:
LogInfo(0x31123000). What does it mean?

pr 6 01:06:02 localhost kernel: md: data-check of RAID array md0
Apr 6 01:06:02 localhost kernel: md: minimum _guaranteed_ speed: 1000
KB/sec/disk.
Apr 6 01:06:02 localhost kernel: md: using maximum available idle IO ba=
ndwidth
(but not more than 200000 KB/sec) for data-check.
Apr 6 01:06:02 localhost kernel: md: using 128k window, over a total of
976759936 blocks.
Apr 6 01:06:02 localhost mdadm: RebuildStarted event detected on md dev=
ice
/dev/md0
Apr 6 01:09:01 localhost /USR/SBIN/CRON[1503]: (root) CMD ( [ -d /var/l=
ib/php5
] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -p=
rin
t0 | xargs -r -0 rm)
Apr 6 01:17:02 localhost /USR/SBIN/CRON[4439]: (root) CMD ( cd / && run=
-parts
--report /etc/cron.hourly)
Apr 6 01:17:44 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 6 01:17:44 localhost last message repeated 9 times
Apr 6 01:31:55 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 6 01:31:55 localhost last message repeated 11 times
Apr 6 01:38:58 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 6 01:38:59 localhost last message repeated 10 times
Apr 6 01:39:01 localhost /USR/SBIN/CRON[12372]: (root) CMD ( [ -d /var/=
lib/php5
] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -p=
ri
nt0 | xargs -r -0 rm)
Apr 6 01:53:32 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 6 01:53:33 localhost last message repeated 11 times
Apr 6 02:04:32 localhost -- MARK --
Apr 6 02:04:41 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 6 02:04:42 localhost last message repeated 13 times
Apr 6 02:07:02 localhost mdadm: Rebuild20 event detected on md device /=
dev/md0
Apr 6 02:09:02 localhost /USR/SBIN/CRON[23206]: (root) CMD ( [ -d /var/=
lib/php5
] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -p=
ri
nt0 | xargs -r -0 rm)
Apr 6 02:17:02 localhost /USR/SBIN/CRON[26105]: (root) CMD ( cd / && ru=
n-parts
--report /etc/cron.hourly)
Apr 6 02:39:01 localhost /USR/SBIN/CRON[1605]: (root) CMD ( [ -d /var/l=
ib/php5
] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -p=
rin
t0 | xargs -r -0 rm)
Apr 6 02:39:34 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 6 02:39:35 localhost last message repeated 10 times
Apr 6 03:04:02 localhost mdadm: Rebuild40 event detected on md device /=
dev/md0
Apr 6 03:09:01 localhost /USR/SBIN/CRON[12430]: (root) CMD ( [ -d /var/=
lib/php5
] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -p=
ri
nt0 | xargs -r -0 rm)
Apr 6 03:15:19 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 6 03:15:20 localhost last message repeated 12 times
Apr 6 03:17:01 localhost /USR/SBIN/CRON[15314]: (root) CMD ( cd / && ru=
n-parts
--report /etc/cron.hourly)
Apr 6 03:20:04 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 6 03:20:05 localhost last message repeated 10 times
Apr 6 03:34:23 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 6 03:34:24 localhost last message repeated 13 times
Apr 6 03:39:01 localhost /USR/SBIN/CRON[23220]: (root) CMD ( [ -d /var/=
lib/php5
] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -p=
ri
nt0 | xargs -r -0 rm)
Apr 6 03:55:02 localhost mdadm: Rebuild60 event detected on md device /=
dev/md0
Apr 6 04:09:01 localhost /USR/SBIN/CRON[1588]: (root) CMD ( [ -d /var/l=
ib/php5
] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -p=
rin
t0 | xargs -r -0 rm)
Apr 6 04:17:01 localhost /USR/SBIN/CRON[4498]: (root) CMD ( cd / && run=
-parts
--report /etc/cron.hourly)


Steps to reproduce: run mdadm checkarray script


------- Comment #1 From Arthur 2008-04-07 04:34:27 [reply] -------

The Distribution is not Lenny, it is Debian etch x86_64


------- Comment #2 From Arthur 2008-04-07 23:07:34 [reply] -------

When I connect all 5 drives to SAS, I get A LOT of the above mentioned =
messages
during the startup and after it. Running checkarray causes a reboot. (p=
ercents
completed may vary up to ten). With one drive connected to SAS I was ab=
le to
complete the array check and even work for 1-2 days.=20


------- Comment #3 From Arthur 2008-04-09 03:50:07 [reply] -------

I recompiled the kernel (2.6.24) with the driver given on LSI download =
page
(mptlinux-4.00.21.00-src.tar.gz). Now it is 4.00.21 insted of default 3=
=2E06.05.
All 5 hard drives are connected to SAS.
host1: ioc0: fw=3D01.23.00.00 bios=3D06.12.00.00 driver=3D4.00.21.00 mp=
i=3D105
LSISAS1068 B1: board_name=3DN/A assembly=3DASUSTek tracer=3DN/A
nvdata_persistent=3D2b00h nvdata_default=3D2b00h
io_delay=3D00 device_delay=3D00
debug_level=3D00000000h

But symptoms remained the same, I still get a lot of error messages:

Apr 9 13:42:31 localhost kernel: ReiserFS: dm-1: found reiserfs format =
"3.6"
with standard journal
Apr 9 13:42:31 localhost kernel: ReiserFS: dm-1: using ordered data mod=
e
Apr 9 13:42:31 localhost kernel: ReiserFS: dm-1: journal params: device=
 dm-1,
size 8192, journal first block 18, max trans len 1024, max batch 900, m=
ax co
mmit age 30, max trans age 30
Apr 9 13:42:31 localhost kernel: ReiserFS: dm-1: checking transaction l=
og
(dm-1)
Apr 9 13:42:31 localhost kernel: ReiserFS: dm-1: Using r5 hash to sort =
names
Apr 9 13:43:23 localhost kernel: md: data-check of RAID array md0
Apr 9 13:43:23 localhost kernel: md: minimum _guaranteed_ speed: 1000
KB/sec/disk.
Apr 9 13:43:23 localhost kernel: md: using maximum available idle IO ba=
ndwidth
(but not more than 200000 KB/sec) for data-check.
Apr 9 13:43:23 localhost kernel: md: using 128k window, over a total of
976759936 blocks.
Apr 9 13:43:23 localhost mdadm: RebuildStarted event detected on md dev=
ice
/dev/md0
Apr 9 13:43:26 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 9 13:43:56 localhost last message repeated 79 times
Apr 9 13:44:57 localhost last message repeated 73 times
Apr 9 13:44:57 localhost last message repeated 8 times
Apr 9 13:45:26 localhost kernel: mptbase: ioc0: LogInfo(0x31123000):
Originator=3D{PL}, Code=3D{Abort}, SubCode(0x3000)
Apr 9 13:45:26 localhost last message repeated 12 times

when I run /usr/share/mdadm/checkarray --cron --all --quiet


------- Comment #4 From Roland Kletzing 2008-05-11 15:05:20 [reply] ---=
----

first off, i would not recommend combining different drives or same dis=
ks via
different paths into a raid volume.
see
http://www.howtofixcomputers.com/forums/scsi/sas-sata-arrays-one-contro=
ller-lsisas1068-17428-3.html

anyhow, that doesn`t explain why you also have issues with 5 drives via=
 sas.

i would recommend asking here:

LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
P:      Eric Moore
M:      Eric.Moore@lsi.com
M:      support@lsi.com
L:      DL-MPTFusionLinux@lsi.com
L:      linux-scsi@vger.kernel.org
W:      http://www.lsilogic.com/support
S:      Supported



_______________________________________________________________________
EINE F=DCR ALLE: die kostenlose WEB.DE-Plattform f=FCr Freunde und Dein=
e
Homepage mit eigenem Namen. Jetzt starten! http://unddu.de/?kid=3Dkid@m=
f2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
