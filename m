From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/4] qla4xxx: Updates for scsi "misc" branch.
Date: Wed, 22 Aug 2012 07:45:23 -0400
Message-ID: <1345635927-22420-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:60374 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755620Ab2HVMCE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 08:02:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest
convenience.

Thanks,
Vikas.

Vikas Chaudhary (4):
      qla4xxx: Fix lockdep warning in qla4xxx_post_work()
      qla4xxx: Clear interrupt while unloading driver.
      qla4xxx: Wait for cmd to complete before chip reset for ISP40XX
      qla4xxx: Update driver version to 5.02.00-k20

 drivers/scsi/qla4xxx/ql4_os.c      |   14 ++++++++++++--
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)
