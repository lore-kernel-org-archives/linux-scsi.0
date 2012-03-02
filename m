From: James Smart <james.smart@emulex.com>
Subject: [PATCH 15/21] lpfc 8.3.30: Change default DA_ID support from
 disabled to enabled
Date: Thu, 1 Mar 2012 22:37:32 -0500
Message-ID: <1330659454.18500.42.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38863 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757618Ab2CBDhw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:37:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Change default DA_ID support from disabled to enabled


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2012-02-27 23:35:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2012-03-01 17:33:51.000000000 -0500
@@ -2575,7 +2575,7 @@ LPFC_VPORT_ATTR_HEX_RW(log_verbose, 0x0,
 # lpfc_enable_da_id: This turns on the DA_ID CT command that deregisters
 # objects that have been registered with the nameserver after login.
 */
-LPFC_VPORT_ATTR_R(enable_da_id, 0, 0, 1,
+LPFC_VPORT_ATTR_R(enable_da_id, 1, 0, 1,
 		  "Deregister nameserver objects before LOGO");
 
 /*



