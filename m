From: andrew.vasquez@qlogic.com
Subject: [PATCH 1/4] qla2xxx: Remove bogus debug-code.
Date: Tue, 7 Feb 2006 08:45:30 -0800
Message-ID: <11393307303158-git-send-email-andrew.vasquez@qlogic.com>
References: <20060207163937.GC1405@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:35722 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1750792AbWBGQpa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 11:45:30 -0500
In-Reply-To: <20060207163937.GC1405@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: andrew.vasquez@qlogic.com

Commit 854165f4245c4a3b4a8cc363ba2050033151e196
inadvertently added some code meant only for testing -- the
driver was ignoring the non-zero function numbers of a
multi-port HBA.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_os.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

fb36644aca91fef1b3af589c73fa0a425e9c7977
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 495ccbc..c4b6c34 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1271,9 +1271,6 @@ int qla2x00_probe_one(struct pci_dev *pd
 	fc_port_t *fcport;
 	struct scsi_host_template *sht;
 
-if (PCI_FUNC(pdev->devfn))
-	goto probe_out;
-
 	if (pci_enable_device(pdev))
 		goto probe_out;
 
-- 
1.1.6.ga2c6


