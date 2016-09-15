From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] scsi: replace broken specification URL
Date: Thu, 15 Sep 2016 15:03:05 +0200
Message-ID: <1473944585-18344-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <7884d730-1d65-73c0-b94d-196bda3211d5@free-electrons.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:40268 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756963AbcIONDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2016 09:03:48 -0400
In-Reply-To: <7884d730-1d65-73c0-b94d-196bda3211d5@free-electrons.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: corbet@lwn.net, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>

The t10.org website containing SCSI-2 draft specifications now requires
to be from a member company to access the documents.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 Documentation/DocBook/scsi.tmpl | 6 +++---
 drivers/scsi/scsicam.c          | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/scsi.tmpl b/Documentation/DocBook/scsi.tmpl
index 4b9b9b286cea..b8b646426321 100644
--- a/Documentation/DocBook/scsi.tmpl
+++ b/Documentation/DocBook/scsi.tmpl
@@ -160,9 +160,9 @@
       <sect2 id="scsicam.c">
         <title>drivers/scsi/scsicam.c</title>
         <para>
-          <ulink url='http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf'>SCSI
-          Common Access Method</ulink> support functions, for use with
-          HDIO_GETGEO, etc.
+          <ulink url='http://www.t10.org/t10docs.htm'>SCSI Common Access
+	  Method</ulink> support functions ('cam-r12b.pdf' document,
+	  registration required), for use with HDIO_GETGEO, etc.
         </para>
 !Edrivers/scsi/scsicam.c
       </sect2>
diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
index 910f4a7a3924..5c446d9ef468 100644
--- a/drivers/scsi/scsicam.c
+++ b/drivers/scsi/scsicam.c
@@ -207,7 +207,8 @@ EXPORT_SYMBOL(scsi_partsize);
  *
  * WORKING                                                    X3T9.2
  * DRAFT                                                        792D
- * see http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf
+ * 'cam-r12b.pdf' document on http://www.t10.org/t10docs.htm
+ * (registration required)
  *
  *                                                        Revision 6
  *                                                         10-MAR-94
-- 
2.7.4

