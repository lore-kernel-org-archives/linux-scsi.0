From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 7/8] mpt fusion: Kconfig cleanup
Date: Fri, 14 Sep 2007 18:50:49 -0600
Message-ID: <20070915005048.GA16851@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48477 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbXIOA7G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 20:59:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Adding 949X, 949E, and 1078 to Kconfig.   Adding "depends on FUSION" required in the FUSION_LOGGING section, and fixing a spelling error.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/Kconfig a/drivers/message/fusion/Kconfig
--- b/drivers/message/fusion/Kconfig	2007-09-13 14:30:29.000000000 -0600
+++ a/drivers/message/fusion/Kconfig	2007-09-14 17:49:46.000000000 -0600
@@ -41,6 +41,8 @@ config FUSION_FC
 	  LSIFC929
 	  LSIFC929X
 	  LSIFC929XL
+	  LSIFC949X
+	  LSIFC949E
 	  Brocade FC 410/420
 
 config FUSION_SAS
@@ -56,6 +58,7 @@ config FUSION_SAS
 	  LSISAS1068
 	  LSISAS1064E
 	  LSISAS1068E
+	  LSISAS1078
 
 config FUSION_MAX_SGE
 	int "Maximum number of scatter gather entries (16 - 128)"
@@ -106,7 +109,6 @@ config FUSION_LAN
 
 config FUSION_LOGGING
 	bool "Fusion MPT logging facility"
-	depends on FUSION
 	---help---
 	  This turns on a logging facility that can be used to debug a number
 	  of Fusion MPT related problems.
@@ -115,7 +117,7 @@ config FUSION_LOGGING
 
 	  echo [level] > /sys/class/scsi_host/host#/debug_level
 
-	  There are various debug levels that an be found in the source:
+	  There are various debug levels that can be found in the source:
 	  file:drivers/message/fusion/mptdebug.h
 
 endif # FUSION
