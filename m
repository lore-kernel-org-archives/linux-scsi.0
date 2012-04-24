From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 0/6] qla4xxx: Update driver version to 5.02.00-k17
Date: Mon, 23 Apr 2012 22:32:31 -0700
Message-ID: <1335245557-17169-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:38525
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674Ab2DXFsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2012 01:48:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to scsi-misc for inclusion in mainline.

Lalit Chandivade (1):
      qla4xxx: Correct early completion of pending mbox.

Manish Rangankar (2):
      qla4xxx: Fix kernel panic during discovery logout.
      qla4xxx: Fix clear ddb mbx command failure issue.

Tej Parkash (2):
      qla4xxx: Add change_queue_depth API support
      qla4xxx: Capture minidump for ISP82XX on firmware failure

Vikas Chaudhary (1):
      qla4xxx: Update driver version to 5.02.00-k17

 drivers/scsi/qla4xxx/ql4_attr.c    |  127 +++++++
 drivers/scsi/qla4xxx/ql4_def.h     |   22 ++
 drivers/scsi/qla4xxx/ql4_fw.h      |   28 ++
 drivers/scsi/qla4xxx/ql4_glbl.h    |    8 +
 drivers/scsi/qla4xxx/ql4_init.c    |   95 ++++-
 drivers/scsi/qla4xxx/ql4_mbx.c     |  111 +++++-
 drivers/scsi/qla4xxx/ql4_nx.c      |  738 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla4xxx/ql4_nx.h      |  192 ++++++++++
 drivers/scsi/qla4xxx/ql4_os.c      |   80 +++-
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-

Thanks,
Vikas.

