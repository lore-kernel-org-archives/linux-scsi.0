From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/5] qla4xxx: Updates for scsi "misc" branch
Date: Wed, 17 Apr 2013 05:15:25 -0400
Message-ID: <1366190130-16556-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:38223 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753260Ab3DQJjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Apr 2013 05:39:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

James,
 
Please apply the following patches to the scsi tree at your earliest
convenience. 

Adheer Chandravanshi (2):
      qla4xxx: Fix smatch warnings
      qla4xxx: Assign values using correct datatype

Vikas Chaudhary (3):
      qla4xxx: Silence gcc warning
      qla4xxx: Fix sparse warning for qla4xxx_sysfs_ddb_tgt_create
      qla4xxx: Update driver version to 5.03.00-k9

Thanks,
Vikas.
