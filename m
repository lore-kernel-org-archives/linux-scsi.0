From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: Re: [RESEND][PATCH 1/1] ipr: add definitions for additional adapter
Date: Thu, 27 Oct 2011 11:58:21 -0700
Message-ID: <4EA9A9CD.7040302@linux.vnet.ibm.com>
References: <20111019230016.134176494@linux.vnet.ibm.com> <4EA04B8E.9030909@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44966 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1J0TJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2011 15:09:13 -0400
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wayneb@linux.vnet.ibm.com>;
	Thu, 27 Oct 2011 14:59:28 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p9RIwWOv287666
	for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2011 14:58:34 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p9RIwMKM025212
	for <linux-scsi@vger.kernel.org>; Thu, 27 Oct 2011 12:58:22 -0600
In-Reply-To: <4EA04B8E.9030909@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

Here is the corrected patch.

---

Add the appropriate definition and table entry for an additional adapter.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |    2 ++
 drivers/scsi/ipr.h |    1 +
 2 files changed, 3 insertions(+)

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2011-10-19 15:53:32.829134947 -0700
+++ b/drivers/scsi/ipr.h	2011-10-27 11:47:05.015146361 -0700
@@ -82,6 +82,7 @@

 #define IPR_SUBS_DEV_ID_57B4    0x033B
 #define IPR_SUBS_DEV_ID_57B2    0x035F
+#define IPR_SUBS_DEV_ID_57C3    0x0353
 #define IPR_SUBS_DEV_ID_57C4    0x0354
 #define IPR_SUBS_DEV_ID_57C6    0x0357
 #define IPR_SUBS_DEV_ID_57CC    0x035C
Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2011-10-19 15:53:30.852967743 -0700
+++ b/drivers/scsi/ipr.c	2011-10-27 11:38:45.039388987 -0700
@@ -9114,6 +9114,8 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B2, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
+		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C3, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_FPGA_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57C4, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROC_ASIC_E2,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B4, 0, 0, 0 },

