From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [PATCH 3 of 3] Fix errors making Docbook documentation
Date: Mon, 06 Jan 2003 14:48:05 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106041150.C74662C0C4@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com, linux-scsi@vger.kernel.org

From:  Craig Wilkie <craig@homerjay.homelinux.org>

  The attached patch (against 2.5.53) modifies the following files: -
  
  Documentation/Docbook/scsidrivers.tmpl - Fix references to the file 
  scsi_mid_low_api.txt which has moved from the source tree to the 
  documentation tree.
  
  This patch partially addresses one of the issues on the Kernel Janitor 
  TODO list -
  
  "someone who knows DocBook, or is willing to learn, should go through 
  and clean up Documentation/DocBook to kill all the warnings that occur 
  during "make pdfdocs" and generally make the documents look nicer, and 
  render smaller PDFs."
  
  Cheers.
  
  -- 
  Craig Wilkie

--- trivial-2.5-bk/Documentation/DocBook/scsidrivers.tmpl.orig	2003-01-06 14:08:34.000000000 +1100
+++ trivial-2.5-bk/Documentation/DocBook/scsidrivers.tmpl	2003-01-06 14:08:34.000000000 +1100
@@ -52,7 +52,7 @@
   </para>
 <para>
 This document can been found in an ASCII text file in the linux kernel 
-source: <filename>drivers/scsi/scsi_mid_low_api.txt</filename> .
+source: <filename>Documentation/scsi/scsi_mid_low_api.txt</filename> .
 It currently hold a little more information than this document. The
 <filename>drivers/scsi/hosts.h</filename> and <filename>
 drivers/scsi/scsi.h</filename> headers contain descriptions of members
@@ -107,7 +107,7 @@
 
   <chapter id="intfunctions">
      <title>Interface Functions</title>
-!Edrivers/scsi/scsi_mid_low_api.txt
+!EDocumentation/scsi/scsi_mid_low_api.txt
   </chapter>
 
   <chapter id="locks">
-- 
  Don't blame me: the Monkey is driving
  File: Craig Wilkie <craig@homerjay.homelinux.org>: [PATCH 3 of 3] Fix errors making Docbook documentation
