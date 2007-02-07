From: "Chris Knipe" <savage@savage.za.org>
Subject: Emulex HBA Issues
Date: Wed, 7 Feb 2007 15:27:44 +0200
Message-ID: <000901c74abb$c0402ec0$0a01a8c0@cenergynetworks.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www16b.your-server.co.za ([196.22.132.16]:2173 "EHLO
	www16b.your-server.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161314AbXBGOAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 09:00:21 -0500
Received: from [41.243.49.220] (helo=superman)
	by www16b.your-server.co.za with esmtpa (Exim 4.63)
	(envelope-from <savage@savage.za.org>)
	id 1HEmqr-0004Lg-18
	for linux-scsi@vger.kernel.org; Wed, 07 Feb 2007 15:28:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a RedHat 9 system running kernel 2.6.16... The system is attached to 
3 x EMC FC4700 DOE's operating as simple JBODs....

Looking at /proc/scsi/scsi, I can clearly see all the devices are visable 
(see below)

However, each time RedHat boots it assigns a different device to a different 
hard drive... For example, one of my CLAR18 disks in Eclosure 3 Bay 3, ends 
up at /dev/sde.  When I reboot, that same drive, will all of a sudden become 
/dev/sdm.  Needless to say with the devices flying arround like this, it is 
impossibly to create any array or use any of the devices...

I have no way to know that any device will have the same name after a 
reboot... Is there any way to fix this??

Thanks,
Chris.


Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 07 Lun: 00
  Vendor: SEAGATE  Model: ST318203 CLAR18  Rev: 3844
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 08 Lun: 00
  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 09 Lun: 00
  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 10 Lun: 00
  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A84
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 11 Lun: 00
  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 12 Lun: 00
  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 13 Lun: 00
  Vendor: SEAGATE  Model: ST318304 CLAR18  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 14 Lun: 00
  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 15 Lun: 00
  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A84
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 16 Lun: 00
  Vendor: SEAGATE  Model: ST336704 CLAR36  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 17 Lun: 00
  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 18 Lun: 00
  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 19 Lun: 00
  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 20 Lun: 00
  Vendor: SEAGATE  Model: ST173404 CLAR72  Rev: 3A90
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 21 Lun: 00
  Vendor: SEAGATE  Model: ST336605 CLAR36  Rev: 4A20
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 22 Lun: 00
  Vendor: SEAGATE  Model: ST336605 CLAR36  Rev: 4A20
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 23 Lun: 00
  Vendor: SEAGATE  Model: ST118202 CLAR18  Rev: 3528
  Type:   Direct-Access                    ANSI SCSI revision: 02 

