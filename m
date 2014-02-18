From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 33/35] pci: add HP/3PAR vendor id to pci_ids.h
Date: Tue, 18 Feb 2014 13:57:57 -0600
Message-ID: <20140218195757.15787.65236.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57126 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaBRT70 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:59:26 -0500
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 7E25B1CC7
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:59:19 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 include/linux/pci_ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 97fbecd..0154d9b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -726,6 +726,7 @@
 #define PCI_DEVICE_ID_SI_7018		0x7018
 
 #define PCI_VENDOR_ID_HP		0x103c
+#define PCI_VENDOR_ID_HP_3PAR		0x1590
 #define PCI_DEVICE_ID_HP_VISUALIZE_EG	0x1005
 #define PCI_DEVICE_ID_HP_VISUALIZE_FX6	0x1006
 #define PCI_DEVICE_ID_HP_VISUALIZE_FX4	0x1008

