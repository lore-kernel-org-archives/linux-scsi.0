From: Rob Landley <rob@landley.net>
Subject: [PATCH 13/15] Update kerneldoc comments in drivers/scsi/scsi_transport_sas.c
Date: Fri, 26 Oct 2007 23:16:50 -0500
Message-ID: <200710262316.50961.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41816
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751425AbXJ0DRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:17:06 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 71CB173938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:19:50 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_transport_sas.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_transport_sas.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -r a868e8217782 drivers/scsi/scsi_transport_sas.c
--- a/drivers/scsi/scsi_transport_sas.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_sas.c	Fri Oct 26 22:44:43 2007 -0500
@@ -1309,6 +1309,7 @@ static void sas_rphy_initialize(struct s
 
 /**
  * sas_end_device_alloc - allocate an rphy for an end device
+ * @parent: which port
  *
  * Allocates an SAS remote PHY structure, connected to @parent.
  *
@@ -1345,6 +1346,8 @@ EXPORT_SYMBOL(sas_end_device_alloc);
 
 /**
  * sas_expander_alloc - allocate an rphy for an end device
+ * @parent: which port
+ * @type: SAS_EDGE_EXPANDER_DEVICE or SAS_FANOUT_EXPANDER_DEVICE
  *
  * Allocates an SAS remote PHY structure, connected to @parent.
  *
@@ -1431,7 +1434,7 @@ EXPORT_SYMBOL(sas_rphy_add);
 
 /**
  * sas_rphy_free  --  free a SAS remote PHY
- * @rphy	SAS remote PHY to free
+ * @rphy: SAS remote PHY to free
  *
  * Frees the specified SAS remote PHY.
  *

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
