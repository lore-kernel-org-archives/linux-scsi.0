From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2 00/14] qla4xxx: Patches for scsi-misc
Date: Fri, 7 Oct 2011 16:55:38 -0700
Message-ID: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:23524
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754785Ab1JHAH1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 20:07:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

This patchset address all the comments posted here:
 - http://www.spinics.net/lists/linux-scsi/msg54819.html
 - http://www.spinics.net/lists/linux-scsi/msg54813.html
 - http://www.spinics.net/lists/linux-scsi/msg54815.html

Please apply the following patches to scsi-misc for inclusion in mainline.

Lalit Chandivade (5):
      qla4xxx: Fix bidirectional CHAP.
      qla4xxx: Do not add duplicate CHAP entry in FLASH
      qla4xxx: Fix exporting boot targets to sysfs
      qla4xxx: Fix getting BIDI CHAP for boot targets
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
 drivers/scsi/qla4xxx/ql4_init.c    |   70 ++++++++-
 drivers/scsi/qla4xxx/ql4_iocb.c    |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c     |  140 +++++++++++++----
 drivers/scsi/qla4xxx/ql4_nx.c      |    8 +
 drivers/scsi/qla4xxx/ql4_os.c      |  207 +++++++++++++++++++-----
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 10 files changed, 683 insertions(+), 77 deletions(-)
 create mode 100644 Documentation/scsi/LICENSE.qla4xxx


Thanks,
Vikas.

