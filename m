From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 00/12] qla2xxx: Feature updates for target.
Date: Thu, 19 Jan 2017 22:27:52 -0800
Message-ID: <1484893684-1255-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0046.outbound.protection.outlook.com ([104.47.32.46]:27104
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751252AbdATG2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Jan 2017 01:28:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Hi Bart,

Please consider this updated series for inclusion in target-pending.

Changes from v3 --> v4

o Fixed warnings reported by smatch tool.
o Fixed indentatation warnings reported by smatch tool.

Changes from v2 --> v3

o Cleaned up sparse warnings reported by you.

Changes from v1 --> v2

o Updated review comments and added Reviewed-by tags for necessary patches.
o We left the one particular review comment to add helper routine to
  be addressed at later time in the follow up bug fixes pathes which we
  will be sending in few weeks.
o Added patch to simplify SRB usage in driver.
o Cleaned up warnings reported by sparse option w=1.

Please apply to target-pending.

Thanks,
Himanshu 

Himanshu Madhani (2):
  qla2xxx: Remove SRR code.
  qla2xxx: Remove unused reverse_ini_mode.

Joe Carnuccio (1):
  qla2xxx: Simplify usage of SRB structure in driver.

Quinn Tran (9):
  qla2xxx: Remove direct access of scsi_status field in se_cmd
  qla2xxx: Cleanup TMF code translation from qla_target.
  qla2xxx: Make trace flags more readable.
  qla2xxx: Fix wrong argument in sp done callback.
  qla2xxx: Use d_id instead of s_id for more clarity.
  qla2xxx: Track I-T nexus as single fc_port struct.
  qla2xxx: Add framework for Async fabric discovery.
  qla2xxx: Add Dual mode support in the driver
  qla2xxx: Improve RSCN handling in driver

 drivers/scsi/qla2xxx/qla_attr.c    |    3 +
 drivers/scsi/qla2xxx/qla_bsg.c     |   23 +-
 drivers/scsi/qla2xxx/qla_def.h     |  306 ++++-
 drivers/scsi/qla2xxx/qla_dfs.c     |   11 +-
 drivers/scsi/qla2xxx/qla_fw.h      |  106 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   72 +-
 drivers/scsi/qla2xxx/qla_gs.c      |  726 +++++++++--
 drivers/scsi/qla2xxx/qla_init.c    | 1612 ++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_inline.h  |   18 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  167 ++-
 drivers/scsi/qla2xxx/qla_isr.c     |  317 +++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  232 ++--
 drivers/scsi/qla2xxx/qla_mr.c      |   48 +-
 drivers/scsi/qla2xxx/qla_os.c      |  330 +++--
 drivers/scsi/qla2xxx/qla_target.c  | 2392 +++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_target.h  |  252 +---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  256 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    4 +-
 18 files changed, 4324 insertions(+), 2551 deletions(-)

-- 
1.8.3.1

