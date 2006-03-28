From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 10/10] Version 2.2.3
Date: Tue, 28 Mar 2006 11:03:44 -0500
Message-ID: <1143561824336-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:62399 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1751216AbWC1QDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:31 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_defs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

67a191e3ddf655e1eef6f65d6e050079aa9b7f83
diff --git a/drivers/scsi/sym53c8xx_2/sym_defs.h b/drivers/scsi/sym53c8xx_2/sym_defs.h
index 3659dd7..defccc4 100644
--- a/drivers/scsi/sym53c8xx_2/sym_defs.h
+++ b/drivers/scsi/sym53c8xx_2/sym_defs.h
@@ -40,7 +40,7 @@
 #ifndef SYM_DEFS_H
 #define SYM_DEFS_H
 
-#define SYM_VERSION "2.2.2"
+#define SYM_VERSION "2.2.3"
 #define SYM_DRIVER_NAME	"sym-" SYM_VERSION
 
 /*
-- 
1.2.4.g375a5


