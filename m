From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Doc: Docbook: Change wikipedia's URL from http to https in scsi.tmpl
Date: Thu, 18 Jun 2015 23:44:25 +0900
Message-ID: <1434638665-5761-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, corbet@lwn.net, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Recently wikipedia announced to secure access to the servers.
Now all http access re-route to https.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/scsi.tmpl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/scsi.tmpl b/Documentation/DocBook/scsi.tmpl
index 324b534..4b9b9b2 100644
--- a/Documentation/DocBook/scsi.tmpl
+++ b/Documentation/DocBook/scsi.tmpl
@@ -81,7 +81,7 @@
         SAS, Fibre Channel, FireWire, and ATAPI devices.  SCSI packets are
         also commonly exchanged over Infiniband,
         <ulink url='http://i2o.shadowconnect.com/faq.php'>I20</ulink>, TCP/IP
-        (<ulink url='http://en.wikipedia.org/wiki/ISCSI'>iSCSI</ulink>), even
+        (<ulink url='https://en.wikipedia.org/wiki/ISCSI'>iSCSI</ulink>), even
         <ulink url='http://cyberelk.net/tim/parport/parscsi.html'>Parallel
         ports</ulink>.
       </para>
-- 
2.4.4.408.g16da57c

