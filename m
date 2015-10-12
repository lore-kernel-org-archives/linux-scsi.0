From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/25] HiSilicon SAS driver
Date: Mon, 12 Oct 2015 23:20:12 +0800
Message-ID: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:11581 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbbJLPFT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:05:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

This is the driver patchset for the HiSilicon SAS driver. The driver
is a platform driver.

The driver will support multiple revisions of HW. Currently only "v1"
HW is supported.

The driver uses libsas framework within the SCSI framework.

The v1 HW supports SSP and SMP, but not STP/SATA.


John Garry (25):
  [SCSI] sas: centralise ssp frame information units
  devicetree: bindings: scsi: HiSi SAS
  scsi: hisi_sas: add initial bare driver
  scsi: hisi_sas: add scsi host registration
  scsi: hisi_sas: allocate memories and create pools
  scsi: hisi_sas: add slot init code
  scsi: hisi_sas: add ioremap for device HW
  scsi: hisi_sas: add cq structure initialization
  scsi: hisi_sas: add phy SAS ADDR initialization
  scsi: hisi_sas: add misc HBA initialization
  scsi: hisi_sas: add v1 hardware register definitions
  scsi: hisi_sas: add v1 HW initialisation code
  scsi: hisi_sas: add path from phyup irq to SAS framework
  scsi: hisi_sas: add ssp command function
  scsi: hisi_sas: add cq interrupt handler
  scsi: hisi_sas: add dev_found and port_formed
  scsi: hisi_sas: add abnormal irq handler
  scsi: hisi_sas: add dev_gone and port_deformed
  scsi: hisi_sas: add bcast interrupt handler
  scsi: hisi_sas: add smp protocol support
  scsi: hisi_sas: add scan finished and start
  scsi: hisi_sas: add tmf methods
  scsi: hisi_sas: add control phy handler
  scsi: hisi_sas: add fatal irq handler
  MAINTAINERS: add maintainer for HiSi SAS driver

 .../devicetree/bindings/scsi/hisilicon-sas.txt     |   63 +
 MAINTAINERS                                        |    7 +
 drivers/scsi/Kconfig                               |    1 +
 drivers/scsi/Makefile                              |    1 +
 drivers/scsi/aic94xx/aic94xx_sas.h                 |   49 +-
 drivers/scsi/hisi_sas/Kconfig                      |    5 +
 drivers/scsi/hisi_sas/Makefile                     |    2 +
 drivers/scsi/hisi_sas/hisi_sas.h                   |  406 +++++
 drivers/scsi/hisi_sas/hisi_sas_init.c              |  489 ++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 1115 ++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             | 1850 ++++++++++++++++++++
 include/scsi/sas.h                                 |   74 +
 12 files changed, 4019 insertions(+), 43 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
 create mode 100644 drivers/scsi/hisi_sas/Kconfig
 create mode 100644 drivers/scsi/hisi_sas/Makefile
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas.h
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_init.c
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_main.c
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c

-- 
1.9.1

