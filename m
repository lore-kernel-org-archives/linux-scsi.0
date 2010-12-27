From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 7/8] [SCSI] scst: Correct SCST core version number
Date: Mon, 27 Dec 2010 14:46:02 +0100
Message-ID: <201012271446.02093.bvanassche@acm.org>
References: <201012271435.33778.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:53006 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab0L0NqY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 08:46:24 -0500
In-Reply-To: <201012271435.33778.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

Change the version number of the SCST core from 2.1.0-pre1 into 2.0.0.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scst/scst.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scst/scst.h b/include/scst/scst.h
index e44547a..9034624 100644
--- a/include/scst/scst.h
+++ b/include/scst/scst.h
@@ -48,7 +48,7 @@
 #define SCST_VERSION(a, b, c, d)    (((a) << 24) + ((b) << 16) + ((c) << 8) + d)
 #define SCST_VERSION_CODE	    SCST_VERSION(2, 0, 0, 0)
 #define SCST_VERSION_STRING_SUFFIX
-#define SCST_VERSION_STRING	    "2.1.0-pre1" SCST_VERSION_STRING_SUFFIX
+#define SCST_VERSION_STRING	    "2.0.0" SCST_VERSION_STRING_SUFFIX
 #define SCST_INTERFACE_VERSION	    \
 		SCST_VERSION_STRING "$Revision: 3139 $" SCST_CONST_VERSION
 
-- 
1.7.1

