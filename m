From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: A question on Linux SCSI low-level driver
Date: Mon, 10 May 2004 12:55:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFEA@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:64190 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S261351AbUEJR4A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 13:56:00 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Thanks for the information, Doug.  It helps a lot!

I downloaded scsi_debug from the Internet.  scsi_debug.c and scsi_debug.h also exist under RH Linux 9 /usr/src/linux-2.4.20-8/drivers/scsi/.  I tried to compile it as a module but got errors like this:

[root@localhost scsi]# pwd
/usr/src/linux-2.4.20-8/drivers/scsi
[root@localhost scsi]#
[root@localhost scsi]# make modules
make -C aic7xxx modules
make[1]: Entering directory `/usr/src/linux-2.4.20-8/drivers/scsi/aic7xxx'
make[1]: Nothing to be done for `modules'.
make[1]: Leaving directory `/usr/src/linux-2.4.20-8/drivers/scsi/aic7xxx'
[root@localhost scsi]#
[root@localhost scsi]#
[root@localhost scsi]# make
make -C aic7xxx
make[1]: Entering directory `/usr/src/linux-2.4.20-8/drivers/scsi/aic7xxx'
make all_targets
make[2]: Entering directory `/usr/src/linux-2.4.20-8/drivers/scsi/aic7xxx'
make[2]: Nothing to be done for `all_targets'.
make[2]: Leaving directory `/usr/src/linux-2.4.20-8/drivers/scsi/aic7xxx'
make[1]: Leaving directory `/usr/src/linux-2.4.20-8/drivers/scsi/aic7xxx'
make all_targets
make[1]: Entering directory `/usr/src/linux-2.4.20-8/drivers/scsi'
make[1]: Nothing to be done for `all_targets'.
make[1]: Leaving directory `/usr/src/linux-2.4.20-8/drivers/scsi'
[root@localhost scsi]#
[root@localhost scsi]#

I'm not familiar with the process.  What did I miss and how to compile each low-level driver under /usr/src/linux-2.4.20-8/drivers/scsi as a module from the command line?

Thanks,


Lee


======================================

> 
> My questions are: 
> 
> - is it (i.e. registering the disks with mid-level driver and doing some
>   simple I/Os) doable if this low-level driver only provides mid-level with
>   bus/target/lun numbers (without any hardware-related information)?

Lee,
See the scsi_debug driver (either in the lk 2.4 or lk 2.6
series). It is a scsi subsystem LLD that is basically a
ram disk so there is no "hardware" information to exchange
with the mid level.
