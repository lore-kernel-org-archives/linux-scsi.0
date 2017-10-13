From: "Madhani, Madhani" <himanshu.madhani@cavium.com>
Subject: [PATCH v2 0/5] qla2xxx: Patches for scsi-misc
Date: Fri, 13 Oct 2017 09:34:02 -0700
Message-ID: <20171013163407.8038-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0045.outbound.protection.outlook.com ([104.47.34.45]:22634
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751964AbdJMQeM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Oct 2017 12:34:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@cavium.com>

Hi Martin,

This series adds support for INTx mode for qla2xxx driver. Also,
adds support for N2N login for FC-NVMe.

Please apply to 4.15/scsi-queue at your earliest convenience.

Changes from v1 -> v2

o Fixed warnings reported by 0-day kernel build.

Thanks,
Himanshu

Duane Grigsby (2):
  qla2xxx: Allow MBC_GET_PORT_DATABASE to query and save the port states
  qla2xxx: Changes to support N2N logins

Himanshu Madhani (3):
  qla2xxx: Add module param ql2xenablemsix
  qla2xxx: Add ATIO-Q processing for INTx mode
  qla2xxx: Update driver version to 10.00.00.02-k

 drivers/scsi/qla2xxx/qla_def.h     |  29 ++++++
 drivers/scsi/qla2xxx/qla_fw.h      |   4 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   5 +
 drivers/scsi/qla2xxx/qla_init.c    | 135 ++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    | 195 +++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c     |  59 +++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c     | 105 ++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_os.c      |   9 ++
 drivers/scsi/qla2xxx/qla_target.c  |  12 ++-
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 10 files changed, 518 insertions(+), 37 deletions(-)

-- 
2.12.0
