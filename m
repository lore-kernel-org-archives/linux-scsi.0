From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 00/17] qla2xxx: Target bug fixes and enchancements.
Date: Thu, 25 Sep 2014 06:14:42 -0400
Message-ID: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

Hi Nicholas/Christoph,

Please apply the following patches at your earliest convenience.
This patchset have target related changes to qla2xxx. I will submit
the target (TCM-LIO) patches in different patch set.

Thanks,
~Saurav
 

Arun Easi (6):
  qla2xxx: Use correct offset to req-q-out for reserve calculation
  qla2xxx: Remove verbose messages in target mode.
  qla2xxx: Enable SLER conditionally in target mode.
  qla2xxx: Add Host reset handling in target mode.
  qla2xxx: Handle chip reset in target mode.
  qla2xxx: Host reset handling in ABTS path.

Himanshu Madhani (6):
  qla2xxx: Fix sparse warnings in tcm_qla2xxx.c
  qla2xxx: fix kernel NULL pointer access
  qla2xxx: Increase room in request queue for sending priority packets
  qla2xxx: fix crash due to task mgmt cmd type
  qla2xxx: Do not send SS_RESIDUAL_UNDER with SAM_STAT_BUSY
  qla2xxx: Add memory barrier before ringing doorbell.

Quinn Tran (2):
  qla2xxx: Add support for QFull throttling and Term Exchange retry
  qla2xxx: Fix hang due to cmd_kref not decrementing

Saurav Kashyap (3):
  qla2xxx: Add counter for message
  qla2xxx: Increase the request queue size to 8K for ISP2031
  qla2xxx: Add flags for tracing the target commands.

 drivers/scsi/qla2xxx/qla_dbg.c     |    6 +-
 drivers/scsi/qla2xxx/qla_def.h     |   19 +
 drivers/scsi/qla2xxx/qla_gbl.h     |    2 +
 drivers/scsi/qla2xxx/qla_init.c    |    4 +
 drivers/scsi/qla2xxx/qla_iocb.c    |   15 +-
 drivers/scsi/qla2xxx/qla_os.c      |    6 +-
 drivers/scsi/qla2xxx/qla_target.c  |  691 ++++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_target.h  |   31 ++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   45 ++-
 9 files changed, 624 insertions(+), 195 deletions(-)

-- 
1.7.7
