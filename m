From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [5/5] - version update
Date: Tue, 9 Mar 2004 15:26:13 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309042613.GE12274@twibble.org>
References: <20040309042300.GA12274@twibble.org> <20040309042400.GB12274@twibble.org> <20040309042442.GC12274@twibble.org> <20040309042525.GD12274@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:64452 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S261533AbUCIE01 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 23:26:27 -0500
Content-Disposition: inline
In-Reply-To: <20040309042525.GD12274@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Move version information from .h to .c so that it's more likely to
get updated as changes are made (the .h file is rarely modified).
Update the version from 2.04 to 2.05

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2004-03-08 12:46:04.236439227 +1100
+++ b/drivers/scsi/dc395x.c	2004-03-08 13:21:15.133020152 +1100
@@ -62,6 +62,10 @@
 #include <linux/pci.h>
 #include <linux/list.h>
 
+#define DC395X_NAME	"dc395x"
+#define DC395X_BANNER	"Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040"
+#define DC395X_VERSION	"v2.05, 2004/03/08"
+
 /*---------------------------------------------------------------------------
                                   Features
  ---------------------------------------------------------------------------*/
diff -du -r a/drivers/scsi/dc395x.h b/drivers/scsi/dc395x.h
--- a/drivers/scsi/dc395x.h	2004-03-08 12:46:06.007166152 +1100
+++ b/drivers/scsi/dc395x.h	2004-03-08 13:21:15.134019998 +1100
@@ -7,21 +7,11 @@
 /*	(SCSI chip set used Tekram ASIC TRM-S1040)			*/
 /*									*/
 /************************************************************************/
-
 #ifndef DC395x_H
 #define DC395x_H
 
 /************************************************************************/
 /*									*/
-/*	Name, Banner and Version					*/
-/*									*/
-/************************************************************************/
-#define DC395X_NAME			"dc395x"
-#define DC395X_BANNER			"Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040"
-#define DC395X_VERSION			"v2.04, 2003/05/19"
-
-/************************************************************************/
-/*									*/
 /*	Initial values							*/
 /*									*/
 /************************************************************************/

-- 
 Jamie Lenehan <lenehan@twibble.org>
