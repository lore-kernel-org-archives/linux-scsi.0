From: Meelis Roos <mroos@linux.ee>
Subject: scsi disk registration - double messages
Date: Tue, 15 Feb 2005 12:01:11 +0200 (EET)
Message-ID: <Pine.SOC.4.61.0502151200470.2239@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Received: from math.ut.ee ([193.40.36.2]:64444 "EHLO math.ut.ee")
	by vger.kernel.org with ESMTP id S261665AbVBOKBO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 05:01:14 -0500
Received: from math.ut.ee (localhost [IPv6:::1])
	by math.ut.ee (8.12.8+Sun/8.12.8/math-1.2) with ESMTP id j1FA1CaW004285
	for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 12:01:12 +0200 (EET)
Received: from localhost (mroos@localhost)
	by math.ut.ee (8.12.8+Sun/8.12.2/Submit) with ESMTP id j1FA1BxC004270
	for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 12:01:11 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is 2.6.11-rc4 on Sun SparcStation5 with onbpard ESP scsi, one 2.1G disk 
and one cdrom.

The messages about registration of sda appear tiwice for some reason. This is 
only cosmetic but still a little strange:

eth0: LANCE 08:00:20:90:36:e5
esp0: IRQ 36 SCSI ID 7 Clk 40MHz CCYC=25000 CCF=8 TOut 167 NCR53C9XF(espfast)
ESP: Total of 1 ESP hosts found, 1 actually in use.
scsi0 : Sparc ESP100A-FAST
   Vendor: IBM       Model: DCAS32160SUN2.1G  Rev: S65A
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: TOSHIBA   Model: XM5701TASUN12XCD  Rev: 0997
   Type:   CD-ROM                             ANSI SCSI revision: 02
esp0: target 3 [period 100ns offset 15 10.00MHz FAST SCSI-II]
SCSI device sda: 4226725 512-byte hdwr sectors (2164 MB)
SCSI device sda: drive cache: write through
SCSI device sda: 4226725 512-byte hdwr sectors (2164 MB)
SCSI device sda: drive cache: write through
  sda: sda1 sda2 sda3 sda4
Attached scsi disk sda at scsi0, channel 0, id 3, lun 0

CONFIG_SCSI=y
# CONFIG_SCSI_PROC_FS is not set
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SATA is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_QLOGICPTI is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SUNESP=y


-- 
Meelis Roos (mroos@linux.ee)
