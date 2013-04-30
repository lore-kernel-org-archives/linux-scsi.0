From: Evgeni Golov <evgeni@debian.org>
Subject: [PATCH] ISCI: add more PCI IDs
Date: Tue, 30 Apr 2013 15:12:48 +0200
Message-ID: <1367327568-12196-1-git-send-email-evgeni@debian.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chi.die-welt.net ([84.246.123.210]:42540 "EHLO chi.die-welt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760611Ab3D3NTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Apr 2013 09:19:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: intel-linux-scu@intel.com, linux-scsi@vger.kernel.org
Cc: Evgeni Golov <evgeni@debian.org>

These are found in e.g. the R2000GZ/GL machines.
---
 drivers/scsi/isci/init.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 2839baa..d1ec2bd 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -82,12 +82,16 @@ static DEFINE_PCI_DEVICE_TABLE(isci_id_table) = {
 	{ PCI_VDEVICE(INTEL, 0x1D67),},
 	{ PCI_VDEVICE(INTEL, 0x1D69),},
 	{ PCI_VDEVICE(INTEL, 0x1D6B),},
+	{ PCI_VDEVICE(INTEL, 0x1D6D),},
+	{ PCI_VDEVICE(INTEL, 0x1D6F),},
 	{ PCI_VDEVICE(INTEL, 0x1D60),},
 	{ PCI_VDEVICE(INTEL, 0x1D62),},
 	{ PCI_VDEVICE(INTEL, 0x1D64),},
 	{ PCI_VDEVICE(INTEL, 0x1D66),},
 	{ PCI_VDEVICE(INTEL, 0x1D68),},
 	{ PCI_VDEVICE(INTEL, 0x1D6A),},
+	{ PCI_VDEVICE(INTEL, 0x1D6C),},
+	{ PCI_VDEVICE(INTEL, 0x1D6E),},
 	{}
 };
 
-- 
1.7.2.5

