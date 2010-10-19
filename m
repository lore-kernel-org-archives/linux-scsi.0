From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: add definitions for a new adapter
Date: Mon, 18 Oct 2010 20:24:34 -0700
Message-ID: <4CBD0F72.6090202@linux.vnet.ibm.com>
References: <20101019032228.745607494@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:51927 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab0JSDYn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2010 23:24:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o9J3EwPf029858
	for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2010 21:14:58 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o9J3OZ8D143894
	for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2010 21:24:40 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o9J3OZWp013283
	for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2010 21:24:35 -0600
In-Reply-To: <20101019032228.745607494@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

There was an addition to the hardware roadmap that includes a new adapter.
This patch adds the new definitions for the adapter.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |    2 ++
 drivers/scsi/ipr.h |    1 +
 2 files changed, 3 insertions(+)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-09-28 10:36:56.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-09-28 17:21:09.000000000 -0700
@@ -9025,6 +9025,8 @@ static struct pci_device_id ipr_pci_tabl
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_574D, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B2, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B4, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-09-28 10:36:54.000000000 -0700
+++ b/drivers/scsi/ipr.h	2010-09-28 10:41:17.000000000 -0700
@@ -82,6 +82,7 @@

 #define IPR_SUBS_DEV_ID_57B4    0x033B
 #define IPR_SUBS_DEV_ID_57B2    0x035F
+#define IPR_SUBS_DEV_ID_57C4    0x0354
 #define IPR_SUBS_DEV_ID_57C6    0x0357
 #define IPR_SUBS_DEV_ID_57CC    0x035C


