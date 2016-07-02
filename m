From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] scsi: replace broken specification URL
Date: Sat,  2 Jul 2016 08:56:36 +0200
Message-ID: <1467442596-31310-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: linux-scsi@vger.kernel.org

The t10.org website containing SCSI-2 draft specifications now requires
to be from a member company to access the documents.

This replaces the now broken link with another public resource
where the specifications can be found.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 Documentation/DocBook/scsi.tmpl | 2 +-
 drivers/scsi/scsicam.c          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/scsi.tmpl b/Documentation/DocBook/scsi.tmpl
index 4b9b9b286cea..41ad3086b7a2 100644
--- a/Documentation/DocBook/scsi.tmpl
+++ b/Documentation/DocBook/scsi.tmpl
@@ -160,7 +160,7 @@
       <sect2 id="scsicam.c">
         <title>drivers/scsi/scsicam.c</title>
         <para>
-          <ulink url='http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf'>SCSI
+          <ulink url='ftp://ftp.uni-duisburg.de/Hardware/SCSI/cam-r12b.pdf'>SCSI
           Common Access Method</ulink> support functions, for use with
           HDIO_GETGEO, etc.
         </para>
diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
index 910f4a7a3924..8144618fe2de 100644
--- a/drivers/scsi/scsicam.c
+++ b/drivers/scsi/scsicam.c
@@ -207,7 +207,7 @@ EXPORT_SYMBOL(scsi_partsize);
  *
  * WORKING                                                    X3T9.2
  * DRAFT                                                        792D
- * see http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf
+ * see ftp://ftp.uni-duisburg.de/Hardware/SCSI/cam-r12b.pdf
  *
  *                                                        Revision 6
  *                                                         10-MAR-94
-- 
2.7.4

