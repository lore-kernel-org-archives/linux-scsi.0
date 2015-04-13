From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH scsi] aacraid: aac_src_intr_message() can be static
Date: Mon, 13 Apr 2015 11:04:31 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F5800E@BBYEXM01.pmc-sierra.internal>
References: <201504101622.qu6odppW%fengguang.wu@intel.com>
 <20150410085338.GA3332@snb>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:33487 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106AbbDMLEd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2015 07:04:33 -0400
In-Reply-To: <20150410085338.GA3332@snb>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, James Bottomley <JBottomley@Odin.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Acked-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

-----Original Message-----
From: kbuild test robot [mailto:fengguang.wu@intel.com] 
Sent: Friday, April 10, 2015 2:24 PM
To: Mahesh Rajashekhara
Cc: kbuild-all@01.org; James Bottomley; Adaptec OEM Raid Solutions; James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH scsi] aacraid: aac_src_intr_message() can be static


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 src.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c index 50f181f..79a3ed1 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -46,7 +46,7 @@
 
 static int aac_src_get_sync_status(struct aac_dev *dev);
 
-irqreturn_t aac_src_intr_message(int irq, void *dev_id)
+static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 {
 	struct aac_msix_ctx *ctx;
 	struct aac_dev *dev;
