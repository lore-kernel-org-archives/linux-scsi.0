From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: [PATCH][SCSI] hptiop: Add new PCI device ID
Date: Thu, 12 Feb 2009 11:28:31 +0800
Message-ID: <200902121128.31303.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.biz.mail.mud.yahoo.com ([68.142.200.252]:42855 "HELO
	smtp104.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756607AbZBLDfW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 22:35:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Add a new PCI device ID.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
---

 hptiop.c |    1 +
 1 file changed, 1 insertion(+)

diff -purN linux-2.6.28-rc2-mm1/drivers/scsi/hptiop.c new/drivers/scsi/hptiop.c
--- linux-2.6.28-rc2-mm1/drivers/scsi/hptiop.c	2008-12-25 07:26:37.000000000 +0800
+++ new/drivers/scsi/hptiop.c	2009-02-12 11:14:56.000000000 +0800
@@ -1251,6 +1251,7 @@ static struct pci_device_id hptiop_id_ta
 	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4321), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },

