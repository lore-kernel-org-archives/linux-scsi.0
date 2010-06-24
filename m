From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ipr: add support for new Obsidian-E embedded adapter
Date: Thu, 24 Jun 2010 13:34:14 -0700
Message-ID: <4C23C146.8000407@linux.vnet.ibm.com>
References: <20100624203107.468479055@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:50011 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab0FXUei (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2010 16:34:38 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5OKNmul030637
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2010 14:23:48 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5OKYNtt072538
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2010 14:34:23 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5OKbRwF020845
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2010 14:37:28 -0600
In-Reply-To: <20100624203107.468479055@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

This patch allows the driver to recognize a new Obsidian-E based adapter that
uses a new subsystem ID.

This patch also fixes a few tab/space problems.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>

---
 drivers/scsi/ipr.c |    2 ++
 drivers/scsi/ipr.h |    9 +++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

Index: b/drivers/scsi/ipr.c
===================================================================
--- a/drivers/scsi/ipr.c	2010-06-21 16:06:37.000000000 -0700
+++ b/drivers/scsi/ipr.c	2010-06-21 16:13:47.000000000 -0700
@@ -8889,6 +8889,8 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B3, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57CC, 0, 0, 0 },
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0,
 	      IPR_USE_LONG_TRANSOP_TIMEOUT | IPR_USE_PCI_WARM_RESET },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-06-21 16:06:38.000000000 -0700
+++ b/drivers/scsi/ipr.h	2010-06-21 16:13:44.000000000 -0700
@@ -62,12 +62,12 @@
 #define IPR_SUBS_DEV_ID_2780	0x0264
 #define IPR_SUBS_DEV_ID_5702	0x0266
 #define IPR_SUBS_DEV_ID_5703	0x0278
-#define IPR_SUBS_DEV_ID_572E  0x028D
-#define IPR_SUBS_DEV_ID_573E  0x02D3
-#define IPR_SUBS_DEV_ID_573D  0x02D4
+#define IPR_SUBS_DEV_ID_572E	0x028D
+#define IPR_SUBS_DEV_ID_573E	0x02D3
+#define IPR_SUBS_DEV_ID_573D	0x02D4
 #define IPR_SUBS_DEV_ID_571A	0x02C0
 #define IPR_SUBS_DEV_ID_571B	0x02BE
-#define IPR_SUBS_DEV_ID_571E  0x02BF
+#define IPR_SUBS_DEV_ID_571E	0x02BF
 #define IPR_SUBS_DEV_ID_571F	0x02D5
 #define IPR_SUBS_DEV_ID_572A	0x02C1
 #define IPR_SUBS_DEV_ID_572B	0x02C2
@@ -82,6 +82,7 @@
 #define IPR_SUBS_DEV_ID_57B4    0x033B
 #define IPR_SUBS_DEV_ID_57B2    0x035F
 #define IPR_SUBS_DEV_ID_57C6    0x0357
+#define IPR_SUBS_DEV_ID_57CC    0x035C

 #define IPR_SUBS_DEV_ID_57B5    0x033C
 #define IPR_SUBS_DEV_ID_57CE    0x035E

