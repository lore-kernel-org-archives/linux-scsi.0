From: Venkatraman S <svenkatr@ti.com>
Subject: [PATCH RESEND 0/3] drivers/scsi/ufs: Misc fixes
Date: Tue, 10 Jul 2012 19:39:21 +0530
Message-ID: <1341929364-9122-1-git-send-email-svenkatr@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47055 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab2GJOJ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jul 2012 10:09:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Venkatraman S <svenkatr@ti.com>

Hi James,
  These patches have been posted to lkml and have been in linux-next
for sometime through Andrew Morton's tree.
 I think they should be taken through your tree for next merge window.

Can you please merge these ? 

Thanks and regards,
Venkat.

Namjae Jeon (1):
  drivers/scsi/ufs: fix incorrect return value about SUCCESS and FAILED

Venkatraman S (2):
  drivers/scsi/ufs: use module_pci_driver
  drivers/scsi/ufs: reverse the ufshcd_is_device_present logic

 drivers/scsi/ufs/ufshcd.c |   35 ++++++++++-------------------------
 1 files changed, 10 insertions(+), 25 deletions(-)

