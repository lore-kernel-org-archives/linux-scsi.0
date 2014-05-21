From: James Smart <james.smart@emulex.com>
Subject: [PATCH V2 0/5] lpfc 10.2.8001.0: Update lpfc to revision 10.2.8001.0
Date: Wed, 21 May 2014 08:04:13 -0400
Message-ID: <1400673853.16422.6.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:4910 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaEUMET (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 08:04:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version to driver version 10.2.8001.0

Note: we've revised our version number string...

This patch set updates the lpfc driver to revision 10.2.8001.0

The patches for 10.2.8001.0 contain:
- Fix for cleaning up stale ring flag and sp_queue_event entries.
- Fix for initializing RRQ bitmap
- Removed obsolete PCI IDs from the driver.
- Fix ExpressLane priority setup
- Update lpfc version to driver version 10.2.8001.0


The patches were cut against scsi.git, branch "misc", with the patches
for 10.2.8000.0 applied.

Note: this patch set does not include the recent lpfc patch from
Brian King. That patch should also be pulled in:
marc.info/?l=linux-scsi&w=2&r=1&s=lpfc&q=b


-- james s


Signed-off-by: James Smart <james.smart@emulex.com>




