From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2 30/30] MAINTAINERS: Add cxlflash driver
Date: Wed, 16 Sep 2015 16:33:23 -0500
Message-ID: <1442439203-50539-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:50821 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbbIPVdv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 17:33:51 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 16 Sep 2015 15:33:51 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id E6F2619D803F
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 15:24:42 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8GLWgCd48234722
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 14:32:42 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8GLXlhE025302
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 15:33:48 -0600
In-Reply-To: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Add stanza for cxlflash SCSI driver.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 310da42..b0b2c3f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3153,6 +3153,15 @@ F:	Documentation/powerpc/cxl.txt
 F:	Documentation/powerpc/cxl.txt
 F:	Documentation/ABI/testing/sysfs-class-cxl
 
+CXLFLASH (IBM Coherent Accelerator Processor Interface CAPI Flash) SCSI DRIVER
+M:	Manoj N. Kumar <manoj@linux.vnet.ibm.com>
+M:	Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/cxlflash/
+F:	include/uapi/scsi/cxlflash_ioctls.h
+F:	Documentation/powerpc/cxlflash.txt
+
 STMMAC ETHERNET DRIVER
 M:	Giuseppe Cavallaro <peppe.cavallaro@st.com>
 L:	netdev@vger.kernel.org
-- 
2.1.0

