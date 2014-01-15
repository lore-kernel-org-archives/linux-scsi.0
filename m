From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 40/41] pci: add HP/3PAR vendor id to pci_ids.h
Date: Wed, 15 Jan 2014 16:39:48 -0600
Message-ID: <20140115223948.5061.57475.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:22351 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaAOVjt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:39:49 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

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

