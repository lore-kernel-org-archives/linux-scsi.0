From: vikas.chaudhary@qlogic.com
Subject: [PATCH 0/8] qla4xxx: Updates for scsi "misc" branch
Date: Thu,  7 Mar 2013 05:43:06 -0500
Message-ID: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:50666 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752971Ab3CGLFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 06:05:22 -0500
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

Manish Dusane (1):
      qla4xxx: Take E-port out of reset before disabling pause frames

Tej Parkash (1):
      qla4xxx: Fixed request queue count manipulation on response path

Vikas Chaudhary (6):
      qla4xxx: Boot from SAN fix for ISP83XX
      qla4xxx: Set graceful reset bit for ISP83XX
      qla4xxx: Fix double reset in case of firmware hung for ISP83XX
      qla4xxx: Pass correct LUN address to firmware in case of lun_reset
      qla4xxx: Fix debug level to avoid floods of same message
      qla4xxx: Update driver version to 5.03.00-k5

