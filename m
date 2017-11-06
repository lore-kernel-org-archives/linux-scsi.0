From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/4] qla2xxx: Add FC-NVMe Target support
Date: Mon, 6 Nov 2017 11:55:26 -0800
Message-ID: <20171106195530.17408-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:34634
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753914AbdKFTzg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Nov 2017 14:55:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin,

This series adds support for FC-NVMe Target.

Patch #1 addes new qla_nvmet files for FC-NVMe Target support. 
Patch #2 adds Kconfig and Makefile changes to prepare code compile.
Patch #3 and #4 has bulk of changes to handle FC-NVMe Target LS4 
processing via Purex pass through path.

Note: All the patches in this series must be applied before they can be compilable.

Please apply them to 4.15/scsi-queue at your earliest convenience.

Thanks,
Himanshu

Anil Gurumurthy (4):
  qla2xxx_nvmet: Add files for FC-NVMe Target support
  qla2xxx_nvmet: Added Makefile and Kconfig changes
  qla2xxx_nvmet: Add FC-NVMe Target LS request handling
  qla2xxx_nvmet: Add FC-NVMe Target handling

 drivers/scsi/qla2xxx/Kconfig      |   1 +
 drivers/scsi/qla2xxx/Makefile     |   3 +-
 drivers/scsi/qla2xxx/qla_dbg.c    |   1 +
 drivers/scsi/qla2xxx/qla_dbg.h    |   2 +
 drivers/scsi/qla2xxx/qla_def.h    |  35 +-
 drivers/scsi/qla2xxx/qla_fw.h     | 263 +++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |  17 +-
 drivers/scsi/qla2xxx/qla_gs.c     |  15 +-
 drivers/scsi/qla2xxx/qla_init.c   |  49 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |  42 +-
 drivers/scsi/qla2xxx/qla_isr.c    |  70 +++
 drivers/scsi/qla2xxx/qla_mbx.c    | 100 +++-
 drivers/scsi/qla2xxx/qla_nvme.h   |  33 --
 drivers/scsi/qla2xxx/qla_nvmet.c  | 783 ++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nvmet.h  | 130 ++++++
 drivers/scsi/qla2xxx/qla_os.c     |  75 ++-
 drivers/scsi/qla2xxx/qla_target.c | 932 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.h |  93 +++-
 18 files changed, 2585 insertions(+), 59 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_nvmet.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nvmet.h

-- 
2.12.0
