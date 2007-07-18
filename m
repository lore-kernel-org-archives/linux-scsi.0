From: Chris Ruehl <aacraidbug@xit.com.hk>
Subject: aacraid 2.6.21+ partition table disappear
Date: Wed, 18 Jul 2007 17:47:37 +0800
Message-ID: <469DE1B9.6030107@xit.com.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from si01.xit.com.hk ([202.67.236.24]:56078 "EHLO si01.xit.com.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbXGRKIF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 06:08:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-scsi vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi all,

I had been last 2 Day in China trying update a Linux (Debian Sarge)
running a 2.6.14.3 to 2.6.21.6 or 2.6.22.1

The boot stuck in a VFS Kernel Panic no root filesystem found.

1) aacraid compiled into kernel - failed
2) as module + initrd                  - failed

the initrd show that the sda with 200GB was found - driver sd
but no partition was found.

Sorry I could not get a serial cable to cover the boot log - and it's 
impossible
to get one if you can't speak Mandarin.

Do you have any hint what I could do?

Thank you
Chris

Controller is
0000:02:08.0 RAID bus controller: Adaptec AAC-RAID (rev 01)
        Subsystem: Adaptec 2120S (Crusader)


kerneloutput   """  2.6.14.3  """

Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
Adaptec aacraid driver (1.1-4 Jan 28 2006 18:35:59)
AAC0: kernel 4.2-0[8205]
AAC0: monitor 4.2-0[8205]
AAC0: bios 4.2-0[8205]
AAC0: serial c49a76
AAC0: Non-DASD support enabled.
scsi0 : aacraid
  Vendor: ADAPTEC   Model: XITArray1         Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST373207LC        Rev: D701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST373207LC        Rev: D701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST373207LC        Rev: D701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST373207LC        Rev: D701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST373207LC        Rev: D701
  Type:   Direct-Access                      ANSI SCSI revision: 03
3ware 9000 Storage Controller device driver for Linux v2.26.02.004.
SCSI device sda: 429920256 512-byte hdwr sectors (220119 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
SCSI device sda: 429920256 512-byte hdwr sectors (220119 MB)
sda: Write Protect is off
sda: Mode Sense: 03 00 00 00
sda: got wrong page
sda: assuming drive cache: write through
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >


-- 
X-IT Management Ltd.
Office A, 14/F, Wing Sing Commercial Bldg.
12 Wing Lok Street, Sheung Wan
Hong Kong

3596 7575  PHONE
3585 5118  FAX

