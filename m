From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/1] scsi_transport_fc: Add missing parenthesis to Point-To-Point description
Date: Thu, 15 Jan 2009 16:51:48 +0100
Message-ID: <20090115155521.261214000@de.ibm.com>
References: <20090115155147.871618000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:46505 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbZAOPzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 10:55:24 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.1/8.13.1) with ESMTP id n0FFtNDx014390
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2009 15:55:23 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0FFtMdS3014860
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2009 16:55:22 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n0FFtL4o008295
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jan 2009 16:55:22 +0100
Content-Disposition: inline; filename=fix-fc-host-typo.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Fix typo by adding closing parenthesis.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/scsi/scsi_transport_fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_transport_fc.c	2009-01-15 16:37:03.000000000 +0100
+++ b/drivers/scsi/scsi_transport_fc.c	2009-01-15 16:37:20.000000000 +0100
@@ -95,7 +95,7 @@ static struct {
 	{ FC_PORTTYPE_NPORT,	"NPort (fabric via point-to-point)" },
 	{ FC_PORTTYPE_NLPORT,	"NLPort (fabric via loop)" },
 	{ FC_PORTTYPE_LPORT,	"LPort (private loop)" },
-	{ FC_PORTTYPE_PTP,	"Point-To-Point (direct nport connection" },
+	{ FC_PORTTYPE_PTP,	"Point-To-Point (direct nport connection)" },
 	{ FC_PORTTYPE_NPIV,		"NPIV VPORT" },
 };
 fc_enum_name_search(port_type, fc_port_type, fc_port_type_names)

-- 
