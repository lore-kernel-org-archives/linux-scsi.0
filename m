From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/3] qla4xxx: Updates for scsi "misc" branch
Date: Sat, 29 Dec 2012 02:24:51 -0500
Message-ID: <1356765894-14001-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:40399 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752037Ab2L2Hob (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Dec 2012 02:44:31 -0500
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

Nilesh Javali (1):
      qla4xxx: Correct the validation to check in get_sys_info mailbox

Vikas Chaudhary (2):
      qla4xxx: Pass correct function param to qla4_8xxx_rd_direct
      qla4xxx: Update driver version to 5.03.00-k3
