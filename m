From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 00/19] qla2xxx/target: Target bug fixes and enchancements.
Date: Thu, 25 Sep 2014 04:09:53 -0400
Message-ID: <1411632612-7320-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:16882 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbaIYIoM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 04:44:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

Hi Nicholas/Christoph,

Please apply the following patches at your earliest convenience.

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

Quinn Tran (3):
  qla2xxx: Add support for QFull throttling and Term Exchange retry
  qla2xxx: Fix hang due to cmd_kref not decrementing
  Target/transport: SCSI Status Respond being sent to Initiator twice.

Saurav Kashyap (4):
  qla2xxx: Add counter for message
  qla2xxx: Increase the request queue size to 8K for ISP2031
  qla2xxx: Add flags for tracing the target commands.
  target: Implement report lun data change unit attention.

 drivers/scsi/qla2xxx/qla_dbg.c               |    6 +-
 drivers/scsi/qla2xxx/qla_def.h               |   19 +
 drivers/scsi/qla2xxx/qla_gbl.h               |    2 +
 drivers/scsi/qla2xxx/qla_init.c              |    4 +
 drivers/scsi/qla2xxx/qla_iocb.c              |   15 +-
 drivers/scsi/qla2xxx/qla_os.c                |    6 +-
 drivers/scsi/qla2xxx/qla_target.c            |  686 +++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_target.h            |   31 ++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |   45 ++-
 drivers/target/target_core_fabric_configfs.c |   28 +
 drivers/target/target_core_transport.c       |    3 +-
 11 files changed, 648 insertions(+), 197 deletions(-)

-- 
1.7.7

