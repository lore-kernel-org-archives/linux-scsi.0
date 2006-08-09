From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 1/3] qla4xxx: clarify doc for probe_adapter
Date: Wed, 09 Aug 2006 13:42:20 -0500
Message-ID: <20060809184220.2021.99439.stgit@bebe.enoyolf.org>
References: <20060809182406.2021.90492.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:11699 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751314AbWHISq6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Aug 2006 14:46:58 -0400
In-Reply-To: <20060809182406.2021.90492.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

Clarify the statments in the kerneldoc header.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f39eb5c..b14e63a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1110,11 +1110,9 @@ static void qla4xxx_do_dpc(void *data)
  * @pdev: pointer to pci_dev structure
  * @pci_device_id: pointer to pci_device entry
  *
- * This routine will probe for Qlogic 4010 iSCSI host adapters.
- * It returns the number of host adapters of a particular
- * type that were found.  It also initializes all data necessary for
- * the driver.	It is passed-in the host number, so that it
- * knows where its first entry is in the scsi_hosts[] array.
+ * This routine will probe for Qlogic 40xx iSCSI host adapters.  It
+ * returns zero if the device successfully configured.  It also
+ * initializes all data necessary for the driver.
  **/
 static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 					   const struct pci_device_id *ent)
