From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Increase default adapter init stage change timeout
Date: Wed, 13 May 2015 08:50:27 -0500
Message-ID: <201505131350.t4DDoS2D008870@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:60965 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934312AbbEMNud (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 09:50:33 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 13 May 2015 07:50:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, stable@vger.kernel.org


Increase the default init stage change timeout from 15 seconds to 30 seconds.
This resolves issues we have seen with some adapters not transitioning
to the first init stage within 15 seconds, which results in adapter
initialization failures.

Cc: stable<stable@vger.kernel.org>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.h~ipr_default_stage_change_timeout drivers/scsi/ipr.h
--- linux/drivers/scsi/ipr.h~ipr_default_stage_change_timeout	2015-05-13 08:44:50.450782164 -0500
+++ linux-bjking1/drivers/scsi/ipr.h	2015-05-13 08:45:06.024737996 -0500
@@ -272,7 +272,7 @@
 #define IPR_RUNTIME_RESET				0x40000000
 
 #define IPR_IPL_INIT_MIN_STAGE_TIME			5
-#define IPR_IPL_INIT_DEFAULT_STAGE_TIME                 15
+#define IPR_IPL_INIT_DEFAULT_STAGE_TIME                 30
 #define IPR_IPL_INIT_STAGE_UNKNOWN			0x0
 #define IPR_IPL_INIT_STAGE_TRANSOP			0xB0000000
 #define IPR_IPL_INIT_STAGE_MASK				0xff000000
_

