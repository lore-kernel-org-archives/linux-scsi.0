From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: [PATCH][SCSI] hptiop: add more PCI device IDs
Date: Fri, 25 Jul 2008 13:29:24 +0800
Message-ID: <200807251329.24263.linux@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.biz.mail.mud.yahoo.com ([68.142.201.178]:45094 "HELO
	smtp109.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751220AbYGYFgN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2008 01:36:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

Add PCI device ID for new adapter models.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
---

 drivers/scsi/hptiop.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -purN linux-2.6.26-rc8/drivers/scsi/hptiop.c linux-2.6.26-rc8-hpt/drivers/scsi/hptiop.c
--- linux-2.6.26-rc8/drivers/scsi/hptiop.c	2008-06-25 09:58:20.000000000 +0800
+++ linux-2.6.26-rc8-hpt/drivers/scsi/hptiop.c	2008-07-24 15:09:50.000000000 +0800
@@ -1249,6 +1249,13 @@ static struct pci_device_id hptiop_id_ta
 	{ PCI_VDEVICE(TTI, 0x3522), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3540), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3530), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x3560), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4322), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4210), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4211), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4310), (kernel_ulong_t)&hptiop_itl_ops },
+	{ PCI_VDEVICE(TTI, 0x4311), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3120), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3122), (kernel_ulong_t)&hptiop_mv_ops },
 	{ PCI_VDEVICE(TTI, 0x3020), (kernel_ulong_t)&hptiop_mv_ops },

