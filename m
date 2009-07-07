From: John Stoffel <john@stoffel.org>
Subject: [PATCH 5/5] Make SCSI SG v4 driver enabled by default and remove EXPERIMENTAL dependency, since udev depends on BSG.
Date: Tue,  7 Jul 2009 11:37:49 -0400
Message-ID: <1246981069-21106-1-git-send-email-john@stoffel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mycroft.westnet.com ([216.187.52.7]:35761 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbZGGPhy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2009 11:37:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John Stoffel <john@stoffel.org>

Signed-off-by: John Stoffel <john@stoffel.org>
---
 block/Kconfig |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index e7d1278..55bbefc 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -45,9 +45,9 @@ config LBD
 	  If unsure, say N.
 
 config BLK_DEV_BSG
-	bool "Block layer SG support v4 (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	---help---
+	bool "Block layer SG support v4"
+	default y
+	help
 	  Saying Y here will enable generic SG (SCSI generic) v4 support
 	  for any block device.
 
@@ -57,7 +57,10 @@ config BLK_DEV_BSG
 	  protocols (e.g. Task Management Functions and SMP in Serial
 	  Attached SCSI).
 
-	  If unsure, say N.
+	  This option is required by recent UDEV versions to properly 
+	  access device serial numbers, etc.
+
+	  If unsure, say Y.
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"
-- 
1.6.3.3

