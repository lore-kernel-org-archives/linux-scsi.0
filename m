From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [0/27]
Date: Thu, 17 Feb 2005 12:34:41 -0500
Message-ID: <4214D5B1.1060701@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:30864 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261158AbVBQRes (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:34:48 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHYir30023
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:34:44 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHYib20548
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:34:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

Adaptec would like to announce its SAS/SATA Linux device driver
for inclusion into the Linux kernel.

The driver supports Adaptec's AIC-94XX chip based, eight port SAS
and SATA 64-bit PCI-X, 133MHz ASIC controller.

The driver source is presented as a broken up BK patch over
the latest scsi-misc-2.6 kernel.  The code is compatible
with both 2.4 and 2.6 kernels.

The authors of this code will be monitoring the mailing list
for your comments.

Thanks,
Luben 


# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/16 16:04:42-05:00 luben@luben.adaptec.com 
#   Adds support for Adaptec AIC-94XX chip based SAS/SATA controllers.
#   This is a SCSI Low-Level Device Driver.
# 
# drivers/scsi/adp94xx/readme.txt
#   2005/02/16 16:04:31-05:00 luben@luben.adaptec.com +289 -0
# 
# drivers/scsi/adp94xx/readme.txt
#   2005/02/16 16:04:31-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/readme.txt
# 
# drivers/scsi/adp94xx/adp94xx_seq.h
#   2005/02/16 16:04:30-05:00 luben@luben.adaptec.com +2840 -0
# 
# drivers/scsi/adp94xx/adp94xx_seq.c
#   2005/02/16 16:04:30-05:00 luben@luben.adaptec.com +2845 -0
# 
# drivers/scsi/adp94xx/adp94xx_seq.h
#   2005/02/16 16:04:30-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_seq.h
# 
# drivers/scsi/adp94xx/adp94xx_seq.c
#   2005/02/16 16:04:30-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_seq.c
# 
# drivers/scsi/adp94xx/adp94xx_sata.h
#   2005/02/16 16:04:29-05:00 luben@luben.adaptec.com +756 -0
# 
# drivers/scsi/adp94xx/adp94xx_sata.c
#   2005/02/16 16:04:29-05:00 luben@luben.adaptec.com +3776 -0
# 
# drivers/scsi/adp94xx/adp94xx_sata.h
#   2005/02/16 16:04:29-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_sata.h
# 
# drivers/scsi/adp94xx/adp94xx_sata.c
#   2005/02/16 16:04:29-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_sata.c
# 
# drivers/scsi/adp94xx/adp94xx_sas.h
#   2005/02/16 16:04:28-05:00 luben@luben.adaptec.com +1101 -0
# 
# drivers/scsi/adp94xx/adp94xx_reg.h
#   2005/02/16 16:04:28-05:00 luben@luben.adaptec.com +2454 -0
# 
# drivers/scsi/adp94xx/adp94xx_sas.h
#   2005/02/16 16:04:28-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_sas.h
# 
# drivers/scsi/adp94xx/adp94xx_reg.h
#   2005/02/16 16:04:28-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_reg.h
# 
# drivers/scsi/adp94xx/adp94xx_osm.h
#   2005/02/16 16:04:27-05:00 luben@luben.adaptec.com +1375 -0
# 
# drivers/scsi/adp94xx/adp94xx_osm.h
#   2005/02/16 16:04:27-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_osm.h
# 
# drivers/scsi/adp94xx/adp94xx_osm.c
#   2005/02/16 16:04:26-05:00 luben@luben.adaptec.com +5486 -0
# 
# drivers/scsi/adp94xx/adp94xx_ioctl.h
#   2005/02/16 16:04:26-05:00 luben@luben.adaptec.com +277 -0
# 
# drivers/scsi/adp94xx/adp94xx_osm.c
#   2005/02/16 16:04:26-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_osm.c
# 
# drivers/scsi/adp94xx/adp94xx_ioctl.h
#   2005/02/16 16:04:26-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_ioctl.h
# 
# drivers/scsi/adp94xx/adp94xx_ioctl.c
#   2005/02/16 16:04:25-05:00 luben@luben.adaptec.com +1041 -0
# 
# drivers/scsi/adp94xx/adp94xx_inline.h
#   2005/02/16 16:04:25-05:00 luben@luben.adaptec.com +1075 -0
# 
# drivers/scsi/adp94xx/adp94xx_ioctl.c
#   2005/02/16 16:04:25-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_ioctl.c
# 
# drivers/scsi/adp94xx/adp94xx_inline.h
#   2005/02/16 16:04:25-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_inline.h
# 
# drivers/scsi/adp94xx/adp94xx_hwi.h
#   2005/02/16 16:04:24-05:00 luben@luben.adaptec.com +1242 -0
# 
# drivers/scsi/adp94xx/adp94xx_hwi.c
#   2005/02/16 16:04:24-05:00 luben@luben.adaptec.com +5675 -0
# 
# drivers/scsi/adp94xx/adp94xx_hwi.h
#   2005/02/16 16:04:24-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_hwi.h
# 
# drivers/scsi/adp94xx/adp94xx_hwi.c
#   2005/02/16 16:04:24-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_hwi.c
# 
# drivers/scsi/adp94xx/adp94xx_discover.h
#   2005/02/16 16:04:23-05:00 luben@luben.adaptec.com +1252 -0
# 
# drivers/scsi/adp94xx/adp94xx_discover.h
#   2005/02/16 16:04:23-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_discover.h
# 
# drivers/scsi/adp94xx/adp94xx_discover.c
#   2005/02/16 16:04:22-05:00 luben@luben.adaptec.com +7418 -0
# 
# drivers/scsi/adp94xx/Makefile
#   2005/02/16 16:04:22-05:00 luben@luben.adaptec.com +22 -0
# 
# drivers/scsi/adp94xx/adp94xx_discover.c
#   2005/02/16 16:04:22-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/adp94xx_discover.c
# 
# drivers/scsi/adp94xx/Makefile
#   2005/02/16 16:04:22-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/Makefile
# 
# drivers/scsi/adp94xx/Kconfig
#   2005/02/16 16:04:21-05:00 luben@luben.adaptec.com +11 -0
# 
# drivers/scsi/adp94xx/Kconfig
#   2005/02/16 16:04:21-05:00 luben@luben.adaptec.com +0 -0
#   BitKeeper file /home/luben/projects/linux/2.6/scsi-misc-2.6/drivers/scsi/adp94xx/Kconfig
# 
# drivers/scsi/Makefile
#   2005/02/16 16:04:21-05:00 luben@luben.adaptec.com +1 -0
#   Add compilation directive for the Adaptec SAS/SATA driver.
# 
# drivers/scsi/Kconfig
#   2005/02/16 16:04:21-05:00 luben@luben.adaptec.com +2 -0
#   Add a configuration menu option of the Adaptec SAS/SATA driver.
# 





