From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: remove reference to pci_driver->owner field.
Date: Fri, 11 Nov 2005 08:19:50 -0800
Message-ID: <20051111161950.GA458@andrew-vasquezs-powerbook-g4-15.local>
References: <20051111080733.12822.9617.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:30245 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1750838AbVKKQTw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 11:19:52 -0500
Content-Disposition: inline
In-Reply-To: <20051111080733.12822.9617.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>

As it has been removed from the upstream sources.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 71dfeba..99465d7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2609,7 +2609,6 @@ qla2xxx_remove_one(struct pci_dev *pdev)
 
 static struct pci_driver qla2xxx_pci_driver = {
 	.name		= "qla2xxx",
-	.owner		= THIS_MODULE,
 	.id_table	= qla2xxx_pci_tbl,
 	.probe		= qla2xxx_probe_one,
 	.remove		= __devexit_p(qla2xxx_remove_one),
