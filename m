From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 00/19] qla2xxx: Patches for scsi "misc" branch.
Date: Wed, 21 Nov 2012 02:40:25 -0500
Message-ID: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:35753 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751876Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com> 

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in the next mainline merge window.

Thanks,
~Saurav 


Andrew Vasquez (2):
  qla2xxx: Clear unsupported 'states' during Get-FW-State queries.
  qla2xxx: Use correct Request-Q-Out register during bidirectional
    request processing

Armen Baloyan (1):
  qla2xxx: No fcport FC-4 type assignment in GA_NXT response.

Chad Dupuis (3):
  qla2xxx: Remove spurious taking of ha->vport_slock spinlock.
  qla2xxx: Move noisy Start scsi failed messages to verbose logging
    level.
  qla2xxx: Update ql2xextended_error_logging parameter description with
    new option.

Joe Carnuccio (4):
  qla2xxx: Add acquiring of risc semaphore before doing ISP reset.
  qla2xxx: Move marking fcport online ahead of setting iiDMA speed.
  qla2xxx: Add 16Gb/s case to get port speed capability.
  qla2xxx: Parameterize the link speed of hba rather than fcport.

Masanari Iida (1):
  qla2xxx: Fix typo in qla2xxx driver.

Saurav Kashyap (8):
  qla2xxx: Honor status value of 2 for report-id acquisition.
  qla2xxx: Fix for warnings reported by sparse.
  qla2xxx: Fix coccinelle warnings in qla2x00_relogin.
  qla2xxx: Add Gen3 PCIe speed 8GT/s to the log message.
  qla2xxx: Fix typo in qla83xx_fw_dump function.
  qla2xxx: Ignore driver ack bit if corresponding presence bit is not
    set.
  qla2xxx: Dont clear drv active on iospace config failure.
  qla2xxx: Display that driver is operating in legacy interrupt mode.

 drivers/scsi/qla2xxx/qla_dbg.c    |    8 +-
 drivers/scsi/qla2xxx/qla_def.h    |    4 +-
 drivers/scsi/qla2xxx/qla_fw.h     |   21 +++++
 drivers/scsi/qla2xxx/qla_gbl.h    |    3 +-
 drivers/scsi/qla2xxx/qla_gs.c     |    6 ++
 drivers/scsi/qla2xxx/qla_init.c   |  153 ++++++++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_iocb.c   |   15 +---
 drivers/scsi/qla2xxx/qla_isr.c    |   42 +++++-----
 drivers/scsi/qla2xxx/qla_mbx.c    |    6 +-
 drivers/scsi/qla2xxx/qla_nx.c     |   83 ++++++++-------------
 drivers/scsi/qla2xxx/qla_os.c     |   50 ++++++++-----
 drivers/scsi/qla2xxx/qla_target.c |    2 +-
 12 files changed, 214 insertions(+), 179 deletions(-)

-- 
1.7.7

