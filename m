From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/4] qla4xxx: Updates for scsi "misc" branch
Date: Fri, 22 Mar 2013 07:08:30 -0400
Message-ID: <1363950514-15483-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:62518 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932745Ab3CVLbQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Mar 2013 07:31:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,

Please apply the following patches to the scsi tree at your earliest
convenience.

Nilesh Javali (1):
      qla4xxx: Skip retry of initialize_adapter only for ISP8XXX

Vikas Chaudhary (3):
      qla4xxx: Added missing check for ISP83XX in CHAP related functions
      qla4xxx: Assign correct CHAP table address to FLT
      qla4xxx: Update driver version to 5.03.00-k6

Thanks,
Vikas.


