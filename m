From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/7] qla4xxx: Update driver version to 5.02.00-k12
Date: Wed, 11 Jan 2012 02:44:14 -0800
Message-ID: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:40964 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab2AKK7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2012 05:59:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to scsi-misc for inclusion in mainline.

Giridhar Malavali (1):
      qla4xxx: Disable generating pause frames in case of FW hung

Karen Higgins (1):
      qla4xxx: Cleanup modinfo display

Mike Hernandez (1):
      qla4xxx: Temperature monitoring for ISP82XX core.

Nilesh Javali (1):
      qla4xxx: Added error logging for firmware abort

Sarang Radke (1):
      qla4xxx: Clear the RISC interrupt bit during FW init

Vikas Chaudhary (2):
      qla4xxx: Update license
      qla4xxx: Update driver version to 5.02.00-k12

 Documentation/scsi/LICENSE.qla4xxx |   23 +---------
 drivers/scsi/qla4xxx/ql4_def.h     |    3 +
 drivers/scsi/qla4xxx/ql4_init.c    |    3 +
 drivers/scsi/qla4xxx/ql4_mbx.c     |    7 +++
 drivers/scsi/qla4xxx/ql4_nx.c      |    5 ++
 drivers/scsi/qla4xxx/ql4_nx.h      |   22 ++++++++-
 drivers/scsi/qla4xxx/ql4_os.c      |   92 +++++++-----------------------------
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 8 files changed, 113 insertions(+), 42 deletions(-)

Thanks,
Vikas.


