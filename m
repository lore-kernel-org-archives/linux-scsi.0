From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 01/22] advansys: Fix VLB driver name
Date: Sun,  9 Sep 2007 08:56:26 -0600
Message-ID: <1189349807325-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:53960 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbXIIO4r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:47 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

You can't have two drivers for the same bus type with the same name.
Since ISA and VLB are both isa_drivers, rename the VLB one to advansys_vlb.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 4d4d7c9..27b3e95 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -16985,7 +16985,7 @@ static struct isa_driver advansys_vlb_driver = {
 	.remove		= __devexit_p(advansys_isa_remove),
 	.driver = {
 		.owner	= THIS_MODULE,
-		.name	= "advansys",
+		.name	= "advansys_vlb",
 	},
 };
 
-- 
1.5.2.4

