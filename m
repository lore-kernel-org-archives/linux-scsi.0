From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 00/15] qla2xxx: Add Target Multiqueue support
Date: Wed, 7 Jun 2017 14:43:18 -0700
Message-ID: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

Hi Nic,

This patch series adds support for multiqueue for qla2xxx target mode driver.

I've also added patch ("qla2xxx: Include Exchange offload/Extended Login
into FW dump") which was dropped from earlier series for rework.

Please apply this series to target-pending for inclusion in 4.13 merge window.

Thanks,
Himanshu
 
Himanshu Madhani (1):
  qla2xxx: Update driver version to 9.01.00.00-k

Quinn Tran (13):
  qla2xxx: Combine Active command arrays.
  qla2xxx: Preparation for Target MQ.
  qla2xxx: Enable Target Multi Queue
  qla2xxx: Add debug knob for user control workload
  qla2xxx: Add fw_started flags to qpair
  qla2xxx: Move fields from qla_hw_data to qla_qpair
  qla2xxx: Use shadow register for ISP27XX
  qla2xxx: Add function call to qpair for door bell
  qla2xxx: Add debug logging routine for qpair
  qla2xxx: Remove unused tgt_enable_64bit_addr flag
  qla2xxx: Remove datasegs_per_cmd and datasegs_per_cont field
  qla2xxx: Move target stat counters from vha to qpair.
  qla2xxx: Include Exchange offload/Extended Login into FW dump

Sawan Chandak (1):
  qla2xxx: Fix mailbox failure while deleting Queue pairs

 drivers/scsi/qla2xxx/qla_attr.c    |    4 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |  150 ++++++
 drivers/scsi/qla2xxx/qla_dbg.h     |   17 +
 drivers/scsi/qla2xxx/qla_def.h     |  119 ++++-
 drivers/scsi/qla2xxx/qla_dfs.c     |  137 ++++-
 drivers/scsi/qla2xxx/qla_gbl.h     |   19 +-
 drivers/scsi/qla2xxx/qla_init.c    |   53 +-
 drivers/scsi/qla2xxx/qla_inline.h  |   44 ++
 drivers/scsi/qla2xxx/qla_iocb.c    |   32 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   95 +++-
 drivers/scsi/qla2xxx/qla_mid.c     |   44 +-
 drivers/scsi/qla2xxx/qla_os.c      |  156 ++++--
 drivers/scsi/qla2xxx/qla_target.c  | 1028 +++++++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_target.h  |   50 +-
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    8 +-
 16 files changed, 1349 insertions(+), 611 deletions(-)

-- 
2.12.0
