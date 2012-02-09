From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 00/11] qla2xxx: Patches for 3.3-rc.
Date: Thu, 9 Feb 2012 11:14:02 -0800
Message-ID: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:49171
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754445Ab2BITaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:30 -0500
Received: from mail63-ch1 (localhost [127.0.0.1])	by mail63-ch1-R.bigfish.com
 (Postfix) with ESMTP id 1EFBA2A0555	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:30:29 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches for 3.3-rc.

Thanks,
Chad

Andrew Vasquez (4):
  qla2xxx: Add an "is reset active" helper.
  qla2xxx: Clear options-flags while issuing stop-firmware mbx command.
  qla2xxx: Remove errant clearing of MBX_INTERRUPT flag during CT-IOCB
    processing.
  qla2xxx: Correct out of bounds read of ISP2200 mailbox registers.

Arun Easi (1):
  qla2xxx: Propagate up abort failures.

Chad Dupuis (2):
  qla2xxx: Add check for null fcport references in
    qla2xxx_queuecommand.
  qla2xxx: Update version number to 8.03.07.13-k.

Giridhar Malavali (2):
  qla2xxx: Complete mailbox command timedout to avoid initialization
    failures during next reset cycle.
  qla2xxx: Proper detection of firmware abort error code for ISP82xx.

Michael Christie (1):
  qla2xxx: Remove check for null fcport from host reset handler.

Shyam Sundar (1):
  qla2xxx: Remove resetting memory during device initialization for
    ISP82xx.

 drivers/scsi/qla2xxx/qla_attr.c    |   13 +++------
 drivers/scsi/qla2xxx/qla_bsg.c     |   50 ++++++-----------------------------
 drivers/scsi/qla2xxx/qla_dbg.c     |    3 +-
 drivers/scsi/qla2xxx/qla_def.h     |    1 +
 drivers/scsi/qla2xxx/qla_inline.h  |   13 +++++++++
 drivers/scsi/qla2xxx/qla_isr.c     |    1 -
 drivers/scsi/qla2xxx/qla_mbx.c     |    7 ++++-
 drivers/scsi/qla2xxx/qla_nx.c      |   15 +----------
 drivers/scsi/qla2xxx/qla_os.c      |   19 ++++++--------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 10 files changed, 45 insertions(+), 79 deletions(-)


