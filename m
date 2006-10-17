From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 1/2] cciss: change PCI ID for bug workaround
Date: Tue, 17 Oct 2006 16:10:27 -0500
Message-ID: <20061017211027.GA17874@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:37769 "EHLO palrel13.hp.com")
	by vger.kernel.org with ESMTP id S1750703AbWJQVK3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 17:10:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

PATCH 1/2
Changed E500 subsystem ID to work around a firmware bug. If a P[48]00
is discovered first a bogus banner string will be displayed at POST

---
commit 499cc64fc708f3a25985bea3b77b40c3448ccbf8
tree 711558d2965c618fa88283fa56c7cb78ce090efb
parent 43f82216f0bd114599f4a221ae6924f3658a0c9a
author Mike Miller <mikem@beardog.cca.cpqcorp.net> Tue, 17 Oct 2006 14:42:43 -0500
committer Mike Miller <mikem@beardog.cca.cpqcorp.net> Tue, 17 Oct 2006 14:42:43 -0500

Signed-off-by: Mike Miller <mikem@beardog.cca.cpqcorp.net>

 drivers/block/cciss.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index dcccaf2..a0a1dd9 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -81,7 +81,7 @@ static const struct pci_device_id cciss_
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3213},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3214},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSD,     0x103C, 0x3215},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3233},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3237},
 	{0,}
 };
 
@@ -110,7 +110,7 @@ static struct board_type products[] = {
 	{0x3213103C, "Smart Array E200i", &SA5_access},
 	{0x3214103C, "Smart Array E200i", &SA5_access},
 	{0x3215103C, "Smart Array E200i", &SA5_access},
-	{0x3233103C, "Smart Array E500", &SA5_access},
+	{0x3237103C, "Smart Array E500", &SA5_access},
 };
 
 /* How long to wait (in milliseconds) for board to go into simple mode */
