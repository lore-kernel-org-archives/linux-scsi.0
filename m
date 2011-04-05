From: Michal Marek <mmarek@suse.cz>
Subject: [PATCH 21/34] aacraid: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:08 +0200
Message-ID: <1302015561-21047-22-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44465 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab1DEO7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:38 -0400
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/scsi/aacraid/linit.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 2c93d94..7babcbb 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -58,7 +58,6 @@
 #ifndef AAC_DRIVER_BRANCH
 #define AAC_DRIVER_BRANCH		""
 #endif
-#define AAC_DRIVER_BUILD_DATE		__DATE__ " " __TIME__
 #define AAC_DRIVERNAME			"aacraid"
 
 #ifdef AAC_DRIVER_BUILD
@@ -66,7 +65,7 @@
 #define str(x) _str(x)
 #define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION "[" str(AAC_DRIVER_BUILD) "]" AAC_DRIVER_BRANCH
 #else
-#define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION AAC_DRIVER_BRANCH " " AAC_DRIVER_BUILD_DATE
+#define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION AAC_DRIVER_BRANCH
 #endif
 
 MODULE_AUTHOR("Red Hat Inc and Adaptec");
-- 
1.7.4.1

