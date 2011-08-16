From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 0/9] qla2xxx: Patches for 3.1-rc
Date: Tue, 16 Aug 2011 11:29:21 -0700
Message-ID: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26888 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab1HPSjd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:39:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches for 3.1-rc.

Thanks,
Chad

Andrew Vasquez (1):
  qla2xxx: Correct inadvertent loop state transitions during
    port-update handling.

Arun Easi (2):
  qla2xxx: T10 DIF - Handle uninitalized sectors.
  qla2xxx: T10 DIF - Fix incorrect error reporting.

Chad Dupuis (3):
  qla2xxx: Fix qla24xx revision check while enabling interrupts.
  qla2xxx: Double check for command completion if abort mailbox command
    fails.
  qla2xxx: Update version number to 8.03.07.07-k.

Saurav Kashyap (3):
  qla2xxx: Acquire hardware lock while manipulating dsd list.
  qla2xxx: Save and restore irq in the response queue interrupt
    handler.
  qla2xxx: Set the task attributes after memsetting fcp cmnd.

 drivers/scsi/qla2xxx/qla_attr.c    |    7 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |   36 +++---
 drivers/scsi/qla2xxx/qla_def.h     |    2 +
 drivers/scsi/qla2xxx/qla_fw.h      |    5 +
 drivers/scsi/qla2xxx/qla_init.c    |    3 -
 drivers/scsi/qla2xxx/qla_inline.h  |   29 ++++
 drivers/scsi/qla2xxx/qla_iocb.c    |  282 ++++++++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c     |  109 +++++++++++---
 drivers/scsi/qla2xxx/qla_mid.c     |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c      |   25 ++--
 drivers/scsi/qla2xxx/qla_os.c      |   30 +++-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 12 files changed, 415 insertions(+), 117 deletions(-)


