From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH scsi 1/2] Add maintainer for csiostor driver
Date: Thu, 10 Sep 2015 16:03:51 -0700
Message-ID: <1441926232-16091-2-git-send-email-anish@chelsio.com>
References: <1441926232-16091-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:29143 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751018AbbIJXER (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2015 19:04:17 -0400
In-Reply-To: <1441926232-16091-1-git-send-email-anish@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@odin.com, hare@suse.de, hch@lst.de, praveenm@chelsio.com, hariprasad@chelsio.com, Anish Bhatt <anish@chelsio.com>

Add Praveen Madhavan as maintainer for Chelsio FCoE
driver (csiostor)

Signed-off-by: Anish Bhatt <anish@chelsio.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2d3d55c..88cfbaf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2641,6 +2641,13 @@ M:	Joe Perches <joe@perches.com>
 S:	Maintained
 F:	scripts/checkpatch.pl
 
+CHELSIO FCOE SCSI DRIVER
+M:      Praveen Madhavan <praveenm@chelsio.com>
+L:      linux-scsi@vger.kernel.org
+W:      http://www.chelsio.com
+S:      Supported
+F:      drivers/scsi/csiostor/
+
 CHINESE DOCUMENTATION
 M:	Harry Wei <harryxiyou@gmail.com>
 L:	xiyoulinuxkernelgroup@googlegroups.com (subscribers-only)
-- 
2.5.1

