From: Dan Aloni <da-x@monatomic.org>
Subject: [PATCH] add two SCSI command opcodes
Date: Thu, 19 Apr 2007 18:10:54 +0300
Message-ID: <20070419151053.GA10199@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1766785AbXDSPLO@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Applies for 2.6.20.7 and beyond.

Signed-off-by: Dan Aloni <da-x@monatomic.org>

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5c0e979..dff842a 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -103,6 +103,7 @@ extern const unsigned char scsi_command_size[8];
 #define READ_12               0xa8
 #define WRITE_12              0xaa
 #define WRITE_VERIFY_12       0xae
+#define VERIFY_12             0xaf
 #define SEARCH_HIGH_12        0xb0
 #define SEARCH_EQUAL_12       0xb1
 #define SEARCH_LOW_12         0xb2
@@ -111,6 +112,7 @@ extern const unsigned char scsi_command_size[8];
 #define WRITE_LONG_2          0xea
 #define READ_16               0x88
 #define WRITE_16              0x8a
+#define WRITE_VERIFY_16       0x8e
 #define VERIFY_16	      0x8f
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
