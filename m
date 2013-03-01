From: James Smart <james.smart@emulex.com>
Subject: [PATCH 9/11] lpfc 8.3.38: Fix default value for lpfc_enable_rrq.
Date: Fri, 1 Mar 2013 16:38:01 -0500
Message-ID: <1362173881.8283.26.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41708 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3CAVj3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 16:39:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix default value for lpfc_enable_rrq.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-02-27 08:17:26.095047546 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-02-27 08:17:34.450047736 -0500
@@ -2302,7 +2302,7 @@ static DEVICE_ATTR(lpfc_enable_npiv, S_I
 LPFC_ATTR_R(fcf_failover_policy, 1, 1, 2,
 	"FCF Fast failover=1 Priority failover=2");
 
-int lpfc_enable_rrq;
+int lpfc_enable_rrq = 2;
 module_param(lpfc_enable_rrq, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_enable_rrq, "Enable RRQ functionality");
 lpfc_param_show(enable_rrq);



