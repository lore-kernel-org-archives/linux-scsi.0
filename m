From: Cory Visi <visi@gcinfotech.com>
Subject: Fw: Problems with LSI MegaRaid 1068e
Date: Wed, 26 Dec 2007 17:28:23 -0500
Message-ID: <OF44D4EF8E.70F7EF78-ON852573BD.007B49CE-852573BD.007B72BD@gcinfotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server02.globalcareers.com ([216.254.106.114]:52491 "EHLO
	server02.globalcareers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbXLZW2d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Dec 2007 17:28:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreenivas.Bagalkote@lsi.com, Sumant.Patro@lsi.com, Neela.Kolli@engenio.com, linux-scsi@vger.kernel.org

To whom it may concern:

I am working with a SuperMicro "Super Server" AS2020A-8RB with an 
integrated LSI MegaRaid 1068e (Firmware M1068e.01.08221427R).

The configuation uses 3x 73 GB SAS drives in a RAID 5 configuration (using 
the RAID key/iButton).

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
