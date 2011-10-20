From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: add CCIN definition for Blue Hawk adapter
Date: Thu, 20 Oct 2011 07:55:47 -0700
Message-ID: <4EA03673.1090905@linux.vnet.ibm.com>
References: <20111019230016.134176494@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46703 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab1JTO5I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2011 10:57:08 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p9KEKdPS014376
	for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2011 10:20:39 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p9KEtnIY2638018
	for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2011 10:55:50 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p9KEtn0Q027423
	for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2011 10:55:49 -0400
In-Reply-To: <20111019230016.134176494@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

Add the appropriate definitions and table entry for the Blue Hawk adapter.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    4 +++-
 drivers/scsi/ipr.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2011-10-19 15:53:30.852967743 -0700
+++ b/drivers/scsi/ipr.c	2011-10-19 15:56:17.363057868 -0700
@@ -9114,8 +9114,10 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B2, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
-		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4, 0, 0, 0 },
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C3, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B4, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B1, 0, 0, 0 },
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2011-10-19 15:53:32.829134947 -0700
+++ b/drivers/scsi/ipr.h	2011-10-19 15:56:20.895356624 -0700
@@ -82,6 +82,7 @@

 #define IPR_SUBS_DEV_ID_57B4    0x033B
 #define IPR_SUBS_DEV_ID_57B2    0x035F
+#define IPR_SUBS_DEV_ID_57C3    0x0353
 #define IPR_SUBS_DEV_ID_57C4    0x0354
 #define IPR_SUBS_DEV_ID_57C6    0x0357
 #define IPR_SUBS_DEV_ID_57CC    0x035C

