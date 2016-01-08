From: John Garry <john.garry@huawei.com>
Subject: [PATCH 00/23] HiSilicon SAS v2 hw support
Date: Fri, 8 Jan 2016 22:15:19 +0800
Message-ID: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This patchset introduces support for the HiSi SAS v2 hw.
The major difference between v1 and v2 hw is support
for SATA/STP.

Known limitation:
- We cannot connect a SATA disk through a 12G expander
  without disabling the STP buffer. Direcly connecting
  a SATA disk to the HBA is ok.

John Garry (23):
  devicetree: bindings: hisi_sas: add v2 HW bindings
  hisi_sas: relocate DEV_IS_EXPANDER
  hisi_sas: set max commands as configurable
  hisi_sas: reduce max itct entries
  hisi_sas: add hisi_sas_err_record_v1
  hisi_sas: rename some fields in hisi_sas_itct
  hisi_sas: add bare v2 hw driver
  hisi_sas: add v2 register definitions
  hisi_sas: add v2 hw init
  hisi_sas: add init_id_frame_v2_hw()
  hisi_sas: add v2 phy init code
  hisi_sas: add v2 int init and phy up handler
  hisi_sas: add v2 phy down handler
  hisi_sas: add v2 channel interrupt handler
  hisi_sas: add v2 SATA interrupt handler
  hisi_sas: add v2 cq interrupt handler
  hisi_sas: add v2 path to send ssp frame
  hisi_sas: add v2 code to send smp command
  hisi_sas: add v2 code for itct setup and free
  hisi_sas: add v2 path to send ATA command
  hisi_sas: add v2 slot error handler
  hisi_sas: add v2 tmf functions
  hisi_sas: update driver version to 1.1

 .../devicetree/bindings/scsi/hisilicon-sas.txt     |   20 +-
 drivers/scsi/hisi_sas/Makefile                     |    2 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |   39 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   36 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   20 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             | 2206 ++++++++++++++++++++
 6 files changed, 2277 insertions(+), 46 deletions(-)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c

-- 
1.9.1
