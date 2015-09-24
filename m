From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v3 29/32] MAINTAINERS: Add cxlflash driver
Date: Thu, 24 Sep 2015 14:44:01 -0500
Message-ID: <1443123841-17817-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:43160 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbbIXTon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2015 15:44:43 -0400
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 24 Sep 2015 13:44:43 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id A321F3E4004C
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 13:44:40 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8OJieNK8716742
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 12:44:40 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8OJiaiR012880
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 13:44:40 -0600
In-Reply-To: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Add stanza for cxlflash SCSI driver.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 274f854..f2f3046 100644
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

