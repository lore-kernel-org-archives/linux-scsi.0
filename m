From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/7] qla4xxx: Updates for scsi "misc" branch
Date: Wed, 10 Oct 2012 07:24:39 -0400
Message-ID: <1349868286-13650-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:27347 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753306Ab2JJLnJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 07:43:09 -0400
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

Adheer Chandravanshi (1):
      qla4xxx: Added new BSG command QLISCSI_VND_ABOUT_FIRMWARE

Harish Zunjarrao (3):
      qla4xxx: Allow reset in link down case
      qla4xxx: Invoke Set Address Control Block using BSG
      qla4xxx: Invoke DisableACB using BSG

Manish Rangankar (2):
      qla4xxx: Add get default DDB support using BSG.
      qla4xxx: Add get DDB support using BSG.

Vikas Chaudhary (1):
      qla4xxx: Update driver version to 5.03.00-k2
