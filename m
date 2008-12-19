From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/11] zfcp: Fix message line break
Date: Fri, 19 Dec 2008 16:56:52 +0100
Message-ID: <20081219155750.239877000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:52506 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYLSQAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 11:00:09 -0500
Content-Disposition: inline; filename=709-zfcp-linebreak.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Felix Beck <felix@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move the closing parenthesis before the line break.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Felix Beck <felix@linux.vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:38:14.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:38:21.000000000 +0100
@@ -1904,7 +1904,7 @@ static void zfcp_fsf_open_unit_handler(s
 				dev_err(&adapter->ccw_device->dev,
 					"Shared read-write access not "
 					"supported (unit 0x%016Lx, port "
-					"0x%016Lx\n)",
+					"0x%016Lx)\n",
 					(unsigned long long)unit->fcp_lun,
 					(unsigned long long)unit->port->wwpn);
 				zfcp_erp_unit_failed(unit, 36, req);

-- 
