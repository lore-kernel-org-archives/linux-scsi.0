From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 9/9] isci: add version number
Date: Fri, 29 Jul 2011 17:17:21 -0700
Message-ID: <20110730001721.28430.28086.stgit@localhost6.localdomain6>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7491 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab1G3ARV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 20:17:21 -0400
In-Reply-To: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/init.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index e78320b..29aa34e 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -64,6 +64,14 @@
 #include "task.h"
 #include "probe_roms.h"
 
+#define MAJ 1
+#define MIN 0
+#define BUILD 0
+#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
+	__stringify(BUILD)
+
+MODULE_VERSION(DRV_VERSION);
+
 static struct scsi_transport_template *isci_transport_template;
 
 static DEFINE_PCI_DEVICE_TABLE(isci_id_table) = {
@@ -540,7 +548,8 @@ static __init int isci_init(void)
 {
 	int err;
 
-	pr_info("%s: Intel(R) C600 SAS Controller Driver\n", DRV_NAME);
+	pr_info("%s: Intel(R) C600 SAS Controller Driver - version %s\n",
+		DRV_NAME, DRV_VERSION);
 
 	isci_transport_template = sas_domain_attach_transport(&isci_transport_ops);
 	if (!isci_transport_template)

