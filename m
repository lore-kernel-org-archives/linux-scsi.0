From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 1/2] MAINTAINERS: ibmvscsi driver maintainer change
Date: Mon, 12 Jan 2015 16:31:34 -0800
Message-ID: <1421109095-18613-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:38100 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbbAMAbu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 19:31:50 -0500
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Mon, 12 Jan 2015 17:31:50 -0700
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 5FB0919D8026
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2015 17:20:24 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t0D0UYxX30081162
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2015 17:30:34 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t0D0VkOn004679
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2015 17:31:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.linux.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

Change maintainer of ibmvscsi driver to Tyrel Datwyler.

Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 79b2e4b..a646b94 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4754,7 +4754,7 @@ S:	Supported
 F:	drivers/net/ethernet/ibm/ibmveth.*
 
 IBM Power Virtual SCSI Device Drivers
-M:	Nathan Fontenot <nfont@linux.vnet.ibm.com>
+M:	Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvscsi*
-- 
1.7.12.2

