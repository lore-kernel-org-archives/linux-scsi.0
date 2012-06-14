From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/4] qla4xxx: Updates for scsi "misc" branch.
Date: Thu, 14 Jun 2012 06:35:47 -0400
Message-ID: <1339670151-26289-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:12862 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755608Ab2FNKwF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2012 06:52:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in mainline.

Vikas Chaudhary (4):
      qla4xxx: multi-session fix for flash ddbs
      qla4xxx: Fix a Sparse warning message
      qla4xxx: Fix Spell check.
      qla4xxx: Update driver version to 5.02.00-k18

 drivers/scsi/qla4xxx/ql4_def.h     |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h    |    3 +-
 drivers/scsi/qla4xxx/ql4_init.c    |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c      |  156 +++++++++++++++++++++++++++++++++---
 drivers/scsi/qla4xxx/ql4_version.h |    2 +-

Thanks,
Vikas.
