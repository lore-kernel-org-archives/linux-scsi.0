From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/5] qla4xxx: Updates for scsi "misc" branch
Date: Fri,  5 Apr 2013 07:06:05 -0400
Message-ID: <1365159970-17672-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:11229 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751663Ab3DEL3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Apr 2013 07:29:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,
 
Please apply the following patches to the scsi tree at your earliest
convenience.

Adheer Chandravanshi (3):
      qla4xxx: Use correct flash ddb offset for ISP40XX
      qla4xxx: Restrict logout from boot target session using session id
      qla4xxx: Use correct value for max flash node entries

Vikas Chaudhary (2):
      qla4xxx: Added print statements to display AENs
      qla4xxx: Update driver version to 5.03.00-k8

Thanks,
Vikas.
