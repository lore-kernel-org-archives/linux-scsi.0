From: Alan Dayley <adayley@adtron.com>
Subject: Mounting multiple LUNs on a single SCSI device
Date: Thu, 30 May 2002 10:30:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20020530102405.01de87f0@adtron.com>
References: <6BD67FFB937FD411A04F00D0B74FE87807C249F0@xrose06.rose.hp.com>
 <1022719300.4124.312.camel@irongate.swansea.linux.org.uk>
 <3CF5AEA4.4050404@metaparadigm.com>
 <1022762307.4123.364.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aland.adtron.com by adtron.com
	with SMTP (MDaemon.PRO.v5.0.5.R)
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2002 10:30:27 -0700
In-Reply-To: <3CF61E66.1050600@metaparadigm.com>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

I am having problems mounting a second LUN on a dual slot PCMCIA SCSI 
device.  I can mount the first LUN by typing mount -t msdos /dev/sda1 
/mnt/card.  When I try /dev/sdb1, I rcv a error message stating mount: 
/dev/sdb1 is not a valid block device.

My OS is Linux RH 7.2.  Thank you for any help you can give.
-
/------------------------------------------
|Alan Dayley                 www.adtron.com
|Staff Software Engineer  602-735-0300 x331
|ADayley@adtron.com
|
|Adtron Corporation
|3710 E. University Drive, Suite 5
|Phoenix, AZ  85034
\-------------------------------------------


