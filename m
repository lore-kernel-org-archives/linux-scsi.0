From: Cory Visi <visi@gcinfotech.com>
Subject: Problems with LSI MegaRaid 1068e
Date: Wed, 26 Dec 2007 14:38:39 -0500
Message-ID: <OF80EB9D91.C7C3893E-ON852573BD.006B1D51-852573BD.006BE89E@gcinfotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server02.globalcareers.com ([216.254.106.114]:40793 "EHLO
	server02.globalcareers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbXLZUGl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Dec 2007 15:06:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: DL-MPTFusionLinux@lsi.com, support@lsi.com, linux-scsi@vger.kernel.org

To whom it may concern:

I am working with a SuperMicro "Super Server" AS2020A-8RB with an 
integrated LSI MegaRaid 1068e (Firmware M1068e.01.08221427R).

The configuation uses 3x 73 GB SAS drives in a RAID 5 configuration (using 
the RAID key).

I am trying to get some combination of kernel and driver to detect these 
drives to know avail.  I have tried a variety of boot CDs, pre-compiled 
modules, and even patching the kernel source myself and compiling the 
driver on the LSI website.  Nothing detects the RAID-5 logical drive.

Using vanilla kernel source version 2.6.23.12 and the LSISAS1068E Linux 
driver version 4.00.13.04-1, I get the following compilation error:

# make modules
CHK     include/linux/version.h
CHK     include/linux/utsrelease.h
CALL    scripts/checksyscalls.sh
CC [M]  drivers/message/fusion/mptsas.o
drivers/message/fusion/mptsas.c: In function `mptsas_hotplug_work': 
drivers/message/fusion/mptsas.c:3605: warning: passing arg 1 of 
`schedule_delayed_work' from incompatible pointer type
drivers/message/fusion/mptsas.c:3651: warning: passing arg 1 of 
`schedule_delayed_work' from incompatible pointer type
drivers/message/fusion/mptsas.c: In function 
`mptsas_broadcast_primative_work': drivers/message/fusion/mptsas.c:4141: 
error: structure has no member named `work'
drivers/message/fusion/mptsas.c:4141: warning: type defaults to `int' in 
declaration of `__mptr'
drivers/message/fusion/mptsas.c:4141: warning: initialization from 
incompatible pointer type
drivers/message/fusion/mptsas.c:4141: error: structure has no member named 
`work'
drivers/message/fusion/mptsas.c: In function `mptsas_reprobe_lun':
drivers/message/fusion/mptsas.c:3289: warning: ignoring return value of 
`scsi_device_reprobe', declared with attribute warn_unused_result
make[3]: *** [drivers/message/fusion/mptsas.o] Error 1
make[2]: *** [drivers/message/fusion] Error 2
make[1]: *** [drivers/message] Error 2
make: *** [drivers] Error 2


What is the easiest way to boot up on a LiveCD for Linux to conduct and 
install that will detect the RAID-5 logical drive on this controller?

What is the best combination of kernel and driver source code that I can 
use on a production system?

Please let me know if you have any suggestions or if there are links to a 
HOWTO or better drivers/patches to use with this hardware.

Thank you,

Cory Visi
Managing Partner
GC InfoTech, LLC
E-mail: visi@gcinfotech.com
Mobile: (203) 912-1173
Office: (203) 327-5700 x4103
Fax:    (203) 353-1035
