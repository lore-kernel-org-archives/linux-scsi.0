From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/17] lpfc 8.3.40: Fix to allow OCM to report FEC status
Date: Fri, 31 May 2013 17:04:50 -0400
Message-ID: <1370034290.17258.32.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5799 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3EaVLY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:11:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix to allow OCM to report FEC status


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2013-05-03 09:24:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2013-05-31 10:58:22.801057743 -0400
@@ -3392,6 +3392,7 @@ static int lpfc_bsg_check_cmd_access(str
 	case MBX_DOWN_LOAD:
 	case MBX_UPDATE_CFG:
 	case MBX_KILL_BOARD:
+	case MBX_READ_TOPOLOGY:
 	case MBX_LOAD_AREA:
 	case MBX_LOAD_EXP_ROM:
 	case MBX_BEACON:
@@ -3422,7 +3423,6 @@ static int lpfc_bsg_check_cmd_access(str
 		}
 		break;
 	case MBX_READ_SPARM64:
-	case MBX_READ_TOPOLOGY:
 	case MBX_REG_LOGIN:
 	case MBX_REG_LOGIN64:
 	case MBX_CONFIG_PORT:



