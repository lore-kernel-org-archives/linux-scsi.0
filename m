From: mathieu.poirier@linaro.org
Subject: [PATCH 0/7] drivers/scsi: randconfig patches for kernel 3.4.patch
Date: Fri, 11 May 2012 16:09:21 -0600
Message-ID: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
List-Id: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

These patches fix miscellaneous problems when working
with make randconfig.  They were discovered on kernel
3.1-rc4 and have been reformatted for 3.4.

Arnd Bergmann (7):
  scsi: mark SCSI_SRP as experimental
  scsi/nsp32: don't pass large values into udelay
  drivers/scsi: use correct __devexit_p annotation
  scsi/advansys: do not build on ARM
  scsi/atp870u: use mdelay instead of large udelay
  scsi/megaraid: fix sparse warnings
  drivers/scsi: some ISA drivers need ISA_DMA_API

 drivers/scsi/Kconfig                        |   10 ++-
 drivers/scsi/atp870u.c                      |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h        |   39 ++++++++++
 drivers/scsi/megaraid/megaraid_sas_base.c   |   46 +++---------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  105 ++++++++++++++-------------
 drivers/scsi/megaraid/megaraid_sas_fp.h     |   22 ++++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   87 +++++++----------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    9 +++
 drivers/scsi/nsp32.c                        |    3 +-
 drivers/scsi/nsp32.h                        |    2 +-
 drivers/scsi/pmcraid.c                      |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c               |    2 +-
 12 files changed, 171 insertions(+), 158 deletions(-)
 create mode 100644 drivers/scsi/megaraid/megaraid_sas_fp.h

-- 
1.7.5.4
