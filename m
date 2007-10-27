From: Rob Landley <rob@landley.net>
Subject: [PATCH 12/15] Update kerneldoc comments in drivers/scsi/scsi_transport_iscsi.c
Date: Fri, 26 Oct 2007 23:16:11 -0500
Message-ID: <200710262316.11563.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41811
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750702AbXJ0DQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:16:27 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 5FAFA73938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:19:11 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_transport_iscsi.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_transport_iscsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -r a868e8217782 drivers/scsi/scsi_transport_iscsi.c
--- a/drivers/scsi/scsi_transport_iscsi.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_iscsi.c	Fri Oct 26 22:44:43 2007 -0500
@@ -328,6 +328,7 @@ EXPORT_SYMBOL_GPL(iscsi_add_session);
  * iscsi_create_session - create iscsi class session
  * @shost: scsi host
  * @transport: iscsi transport
+ * @target_id: which target
  *
  * This can be called from a LLD or iscsi_transport.
  **/
@@ -465,7 +466,7 @@ EXPORT_SYMBOL_GPL(iscsi_create_conn);
 
 /**
  * iscsi_destroy_conn - destroy iscsi class connection
- * @session: iscsi cls session
+ * @conn: iscsi cls session
  *
  * This can be called from a LLD or iscsi_transport.
  **/

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
