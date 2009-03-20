From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/5] ibmvfc: Show host maxframe_size
Date: Fri, 20 Mar 2009 15:44:38 -0500
Message-ID: <200903202044.n2KKiWPt017274@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38660 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZCTUof (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2009 16:44:35 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n2KKfp30013106
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:41:51 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2KKiXId220070
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:44:33 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n2KKiX9j017305
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2009 14:44:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Set show_host_maxframe_size so that maxframe_size gets exported in
sysfs for the host.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_show_host_maxframe_size drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_show_host_maxframe_size	2009-03-18 08:57:43.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-03-18 08:57:43.000000000 -0500
@@ -4195,6 +4195,7 @@ static struct fc_function_template ibmvf
 	.show_host_supported_classes = 1,
 	.show_host_port_type = 1,
 	.show_host_port_id = 1,
+	.show_host_maxframe_size = 1,
 
 	.get_host_port_state = ibmvfc_get_host_port_state,
 	.show_host_port_state = 1,
_
