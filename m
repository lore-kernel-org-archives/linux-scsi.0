From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 2/2] MAINTAINERS: ibmvfc driver maintainer change
Date: Mon, 12 Jan 2015 16:31:35 -0800
Message-ID: <1421109095-18613-2-git-send-email-tyreld@linux.vnet.ibm.com>
References: <1421109095-18613-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:48521 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbbAMAbz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 19:31:55 -0500
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Mon, 12 Jan 2015 17:31:54 -0700
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id E58581FF001D
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2015 17:20:35 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t0D0VqvG50856098
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2015 17:31:52 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t0D0Vpbb005007
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2015 17:31:52 -0700
In-Reply-To: <1421109095-18613-1-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.linux.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Change maintainer of ibmvfc driver to Tyrel Datwyler.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a646b94..f0d7593 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4761,7 +4761,7 @@ F:	drivers/scsi/ibmvscsi/ibmvscsi*
 F:	drivers/scsi/ibmvscsi/viosrp.h
 
 IBM Power Virtual FC Device Drivers
-M:	Brian King <brking@linux.vnet.ibm.com>
+M:	Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvfc*
-- 
1.7.12.2

