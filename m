From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 0/9] qla2xxx: Patches for scsi "misc" branch.
Date: Wed, 10 Jun 2015 11:05:16 -0400
Message-ID: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:63671 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965194AbbFJPtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 11:49:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in the next mainline merge window.

Thanks,
Himanshu

Himanshu Madhani (3):
  qla2xxx: Enable target mode for ISP27XX
  qla2xxx: Remove msleep in qlt_send_term_exchange
  qla2xxx: Enable Target counters in DebugFS.

Kanoj Sarcar (1):
  qla2xxx: fix command initialization in target mode.

Quinn Tran (4):
  qla2xxx: Add flush after updating ATIOQ consumer index.
  qla2xxx: release request queue reservation.
  qla2xxx: adjust debug flags
  qla2xxx: Add FW resource count in DebugFS.

Saurav Kashyap (1):
  qla2xxx: Fix hardware lock/unlock issue causing kernel panic.

 drivers/scsi/qla2xxx/qla_attr.c    |    2 +-
 drivers/scsi/qla2xxx/qla_def.h     |   36 ++++++++++---
 drivers/scsi/qla2xxx/qla_dfs.c     |  106 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h     |    3 +-
 drivers/scsi/qla2xxx/qla_init.c    |   20 ++++---
 drivers/scsi/qla2xxx/qla_iocb.c    |    1 +
 drivers/scsi/qla2xxx/qla_mbx.c     |   31 +++++------
 drivers/scsi/qla2xxx/qla_os.c      |    1 +
 drivers/scsi/qla2xxx/qla_sup.c     |    2 +-
 drivers/scsi/qla2xxx/qla_target.c  |   60 ++++++++++++---------
 drivers/scsi/qla2xxx/qla_target.h  |    3 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    9 ++-
 12 files changed, 208 insertions(+), 66 deletions(-)

-- 
1.7.7

