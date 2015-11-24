From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [RFC PATCH scsi] aacraid: aac_release_resources() can be static
Date: Tue, 24 Nov 2015 12:57:00 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AEC920B44@BBYEXM01.pmc-sierra.internal>
References: <201511101352.WifvAYu2%fengguang.wu@intel.com>
 <20151110055906.GA116383@lkp-hsx03>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:40477 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbbKXM5D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:57:03 -0500
In-Reply-To: <20151110055906.GA116383@lkp-hsx03>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@Odin.com>, Tomas Henzl <thenzl@redhat.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>

Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

-----Original Message-----
From: kbuild test robot [mailto:fengguang.wu@intel.com] 
Sent: Tuesday, November 10, 2015 11:29 AM
To: Mahesh Rajashekhara
Cc: kbuild-all@01.org; linux-scsi@vger.kernel.org; James Bottomley; Tomas Henzl; Murthy Bhat; Karthikeya Sunkesula
Subject: [RFC PATCH scsi] aacraid: aac_release_resources() can be static


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 linit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c index 37375cf..7724583f 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1318,7 +1318,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)  }
 
 #if (defined(CONFIG_PM))
-void aac_release_resources(struct aac_dev *aac)
+static void aac_release_resources(struct aac_dev *aac)
 {
 	int i;
 
