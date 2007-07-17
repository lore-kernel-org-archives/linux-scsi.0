From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH] add PCI_VENDOR_ID macro for Brocade in pci_ids.h
Date: Tue, 17 Jul 2007 13:40:10 +0530
Message-ID: <20070717081010.GA8068@lsil.com>
References: <20070713091330.GA5564@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58809 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857AbXGQIMS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 04:12:18 -0400
Content-Disposition: inline
In-Reply-To: <20070713091330.GA5564@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com, roger.hickerson@lsi.com, ggrignou@brocade.com

Reposting as it is not reached the list.

On Fri, Jul 13, 2007 at 02:43:30PM +0530, Prakash, Sathya wrote:
Adds PCI_VENDOR_ID_BROCADE macro in include/linux/pci_ids.h file. This macro 
is used in MPT Fusion FC drivers to support Brocade branded FC controllers

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>

---

diff -Naurp b/include/linux/pci_ids.h a/include/linux/pci_ids.h
--- b/include/linux/pci_ids.h	2007-07-02 16:20:47.000000000 +0530
+++ a/include/linux/pci_ids.h	2007-07-13 11:34:32.000000000 +0530
@@ -2043,6 +2043,8 @@
 
 #define PCI_VENDOR_ID_ARIMA		0x161f
 
+#define PCI_VENDOR_ID_BROCADE		0x1657
+
 #define PCI_VENDOR_ID_SIBYTE		0x166d
 #define PCI_DEVICE_ID_BCM1250_PCI	0x0001
 #define PCI_DEVICE_ID_BCM1250_HT	0x0002

