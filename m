From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [01/27]
Date: Thu, 17 Feb 2005 12:34:55 -0500
Message-ID: <4214D5BF.40906@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:39312 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262309AbVBQRe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:34:59 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHYwr30115
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:34:58 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHYwb20603
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:34:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Adding a menu option in Kconfig and a compilation directive in Makefile
in SCSI.

diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	2005-02-16 16:08:12 -05:00
+++ b/drivers/scsi/Kconfig	2005-02-16 16:08:12 -05:00
@@ -368,6 +368,8 @@

source "drivers/scsi/aic7xxx/Kconfig.aic79xx"

+source "drivers/scsi/adp94xx/Kconfig"
+
# All the I2O code and drivers do not seem to be 64bit safe.
config SCSI_DPT_I2O
	tristate "Adaptec I2O RAID support "
diff -Nru a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	2005-02-16 16:08:12 -05:00
+++ b/drivers/scsi/Makefile	2005-02-16 16:08:12 -05:00
@@ -62,6 +62,7 @@
obj-$(CONFIG_SCSI_AHA1740)	+= aha1740.o
obj-$(CONFIG_SCSI_AIC7XXX)	+= aic7xxx/
obj-$(CONFIG_SCSI_AIC79XX)	+= aic7xxx/
+obj-$(CONFIG_SCSI_ADP94XX)	+= adp94xx/
obj-$(CONFIG_SCSI_AACRAID)	+= aacraid/
obj-$(CONFIG_SCSI_AIC7XXX_OLD)	+= aic7xxx_old.o
obj-$(CONFIG_SCSI_IPS)		+= ips.o



