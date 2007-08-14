From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH ] Addition to pci_ids.h for ATTO Technology, Inc.
Date: Tue, 14 Aug 2007 16:18:02 -0600
Message-ID: <20070814221802.GA24267@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50392 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764177AbXHNWVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2007 18:21:38 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l7EMK3OS024194
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 15:20:04 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id l7EMLYbZ008978
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 15:21:34 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A new PCI_VENDOR_ID for pci_ids.h.

signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/include/linux/pci_ids.h a/include/linux/pci_ids.h
--- b/include/linux/pci_ids.h	2007-08-08 16:50:40.000000000 -0600
+++ a/include/linux/pci_ids.h	2007-08-14 16:03:40.000000000 -0600
@@ -1461,6 +1461,8 @@
 #define PCI_DEVICE_ID_TOSHIBA_TC86C001_MISC	0x0108
 #define PCI_DEVICE_ID_TOSHIBA_SPIDER_NET 0x01b3
 
+#define PCI_VENDOR_ID_ATTO		0x117c
+
 #define PCI_VENDOR_ID_RICOH		0x1180
 #define PCI_DEVICE_ID_RICOH_RL5C465	0x0465
 #define PCI_DEVICE_ID_RICOH_RL5C466	0x0466
