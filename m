From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 00/13] qla4xxx: Patches for scsi-misc
Date: Mon, 3 Oct 2011 10:29:14 -0700
Message-ID: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:57116
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159Ab1JCRl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 13:41:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to scsi-misc for inclusion in mainline.

Lalit Chandivade (4):
      qla4xxx: Fix bidirectional CHAP
      qla4xxx: Do not add duplicate CHAP entry in FLASH
      qla4xxx: Fix exporting boot targets to sysfs
      qla4xxx: Free Device Database (DDB) reserved by FW

Manish Rangankar (6):
      qla4xxx: Clear DDB map index on the basis of AEN.
      qla4xxx: Fixed session destroy issue on link up-down.
      qla4xxx: Fixed device blocked issue on link up-down.
      qla4xxx: Fixed active session re-open issue.
      qla4xxx: Fixed target discovery failed issue.
      qla4xxx: updated device id check for BFS.

Nilesh Javali (1):
      qla4xxx: Add new FLT firmware region

Vikas Chaudhary (2):
      qla4xxx: Update license
      qla4xxx: Update driver version to 5.02.00-k8

 Documentation/scsi/00-INDEX        |    2 +
 Documentation/scsi/LICENSE.qla4xxx |  310 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla4xxx/ql4_def.h     |   13 ++-
 drivers/scsi/qla4xxx/ql4_fw.h      |    6 +
 drivers/scsi/qla4xxx/ql4_init.c    |   69 ++++++++-
 drivers/scsi/qla4xxx/ql4_iocb.c    |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c     |  135 +++++++++++++----
 drivers/scsi/qla4xxx/ql4_nx.c      |    8 +
 drivers/scsi/qla4xxx/ql4_os.c      |  206 +++++++++++++++++++-----
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 10 files changed, 682 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/scsi/LICENSE.qla4xxx

Thanks,
Vikas.

