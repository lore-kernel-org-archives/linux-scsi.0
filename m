From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] aic7xxx: update documentation
Date: Tue, 24 Jan 2006 10:45:35 +0100
Message-ID: <43D5F73F.2060201@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060906010607020500030609"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:61887 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1030433AbWAXJph (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 04:45:37 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 0B29CED4B
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2006 10:45:36 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060906010607020500030609
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch updates the documentation for aic7xxx and aic79xx with fixes
from the adaptec driver.

--------------060906010607020500030609
Content-Type: text/plain;
 name="0004-aic7xxx-doc-update"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0004-aic7xxx-doc-update"

diff --git a/Documentation/scsi/aic79xx.txt b/Documentation/scsi/aic79xx.txt
--- a/Documentation/scsi/aic79xx.txt
+++ b/Documentation/scsi/aic79xx.txt
@@ -1,5 +1,5 @@
 ====================================================================
-=             Adaptec Ultra320 Family Manager Set v1.3.11          =
+=             Adaptec Ultra320 Family Manager Set                  =
 =                                                                  =
 =                            README for                            =
 =                    The Linux Operating System                    =
@@ -63,6 +63,11 @@ The following information is available i
                               68-pin)
 2. Version History
 
+   3.0	  (December 1st, 2005)
+	- Updated driver to use SCSI transport class infrastructure
+	- Upported sequencer and core fixes from adaptec released
+	  version 2.0.15 of the driver.
+
    1.3.11 (July 11, 2003)
         - Fix several deadlock issues.
         - Add 29320ALP and 39320B Id's.
@@ -194,7 +199,7 @@ The following information is available i
           supported)
         - Support for the PCI-X standard up to 133MHz
         - Support for the PCI v2.2 standard
-	- Domain Validation
+        - Domain Validation
 
    2.2. Operating System Support:
         - Redhat Linux 7.2, 7.3, 8.0, Advanced Server 2.1
@@ -411,77 +416,53 @@ The following information is available i
           http://www.adaptec.com.
 
 
-5. Contacting Adaptec
+5. Adaptec Customer Support
 
    A Technical Support Identification (TSID) Number is required for 
    Adaptec technical support.
     - The 12-digit TSID can be found on the white barcode-type label
-      included inside the box with your product. The TSID helps us 
+      included inside the box with your product.  The TSID helps us 
       provide more efficient service by accurately identifying your 
       product and support status.
+
    Support Options
     - Search the Adaptec Support Knowledgebase (ASK) at
       http://ask.adaptec.com for articles, troubleshooting tips, and
-      frequently asked questions for your product.
+      frequently asked questions about your product.
     - For support via Email, submit your question to Adaptec's 
-      Technical Support Specialists at http://ask.adaptec.com.
+      Technical Support Specialists at http://ask.adaptec.com/.
      
    North America
-    - Visit our Web site at http://www.adaptec.com.
-    - To speak with a Fibre Channel/RAID/External Storage Technical
-      Support Specialist, call 1-321-207-2000,
-      Hours: Monday-Friday, 3:00 A.M. to 5:00 P.M., PST.
-      (Not open on holidays)
-    - For Technical Support in all other technologies including 
-      SCSI, call 1-408-934-7274,
-      Hours: Monday-Friday, 6:00 A.M. to 5:00 P.M., PST.
-      (Not open on holidays)
-    - For after hours support, call 1-800-416-8066 ($99/call, 
-      $149/call on holidays)
-    - To order Adaptec products including software and cables, call
-      1-800-442-7274 or 1-408-957-7274. You can also visit our 
-      online store at http://www.adaptecstore.com
+    - Visit our Web site at http://www.adaptec.com/.
+    - For information about Adaptec's support options, call
+      408-957-2550, 24 hours a day, 7 days a week.
+    - To speak with a Technical Support Specialist,
+      * For hardware products, call 408-934-7274,
+        Monday to Friday, 3:00 am to 5:00 pm, PDT.
+      * For RAID and Fibre Channel products, call 321-207-2000,
+        Monday to Friday, 3:00 am to 5:00 pm, PDT.
+      To expedite your service, have your computer with you.
+    - To order Adaptec products, including accessories and cables,
+      call 408-957-7274.  To order cables online go to
+      http://www.adaptec.com/buy-cables/.
 
    Europe
-    - Visit our Web site at http://www.adaptec-europe.com.
-    - English and French: To speak with a Technical Support 
-      Specialist, call one of the following numbers:
-        - English: +32-2-352-3470
-        - French:  +32-2-352-3460
-      Hours: Monday-Thursday, 10:00 to 12:30, 13:30 to 17:30 CET 
-             Friday, 10:00 to 12:30, 13:30 to 16:30 CET
-    - German: To speak with a Technical Support Specialist,
-      call +49-89-456-40660
-      Hours: Monday-Thursday, 09:30 to 12:30, 13:30 to 16:30 CET
-             Friday, 09:30 to 12:30, 13:30 to 15:00 CET
-    - To order Adaptec products, including accessories and cables:
-        - UK: +0800-96-65-26 or fax +0800-731-02-95
-        - Other European countries: +32-11-300-379
-
-   Australia and New Zealand
-    - Visit our Web site at http://www.adaptec.com.au.
-    - To speak with a Technical Support Specialist, call 
-      +612-9416-0698
-      Hours: Monday-Friday, 10:00 A.M. to 4:30 P.M., EAT
-      (Not open on holidays)
+    - Visit our Web site at http://www.adaptec-europe.com/.
+    - To speak with a Technical Support Specialist, call, or email,
+      * German:  +49 89 4366 5522, Monday-Friday, 9:00-17:00 CET,
+        http://ask-de.adaptec.com/.
+      * French:  +49 89 4366 5533, Monday-Friday, 9:00-17:00 CET,
+	http://ask-fr.adaptec.com/.
+      * English: +49 89 4366 5544, Monday-Friday, 9:00-17:00 GMT,
+	http://ask.adaptec.com/.
+    - You can order Adaptec cables online at
+      http://www.adaptec.com/buy-cables/.
 
    Japan
+    - Visit our web site at http://www.adaptec.co.jp/.
     - To speak with a Technical Support Specialist, call 
-      +81-3-5308-6120 
-      Hours: Monday-Friday, 9:00 a.m. to 12:00 p.m., 1:00 p.m. to
-      6:00 p.m. TSC
-
-   Hong Kong and China
-    - To speak with a Technical Support Specialist, call 
-      +852-2869-7200
-      Hours: Monday-Friday, 10:00 to 17:00.
-    - Fax Technical Support at +852-2869-7100.
-
-   Singapore
-    - To speak with a Technical Support Specialist, call 
-      +65-245-7470
-      Hours: Monday-Friday, 10:00 to 17:00.
-    - Fax Technical Support at +852-2869-7100
+      +81 3 5308 6120, Monday-Friday, 9:00 a.m. to 12:00 p.m.,
+      1:00 p.m. to 6:00 p.m.
 
 -------------------------------------------------------------------
 /*
diff --git a/Documentation/scsi/aic7xxx.txt b/Documentation/scsi/aic7xxx.txt
--- a/Documentation/scsi/aic7xxx.txt
+++ b/Documentation/scsi/aic7xxx.txt
@@ -309,81 +309,57 @@ The following information is available i
    -----------------------------------------------------------------
 
    Example:
-   'options aic7xxx aic7xxx=verbose,no_probe,tag_info:{{},{,,10}},seltime:1"
+   'options aic7xxx aic7xxx=verbose,no_probe,tag_info:{{},{,,10}},seltime:1'
         enables verbose logging, Disable EISA/VLB probing,
         and set tag depth on Controller 1/Target 2 to 10 tags.
 
-3. Contacting Adaptec
+4. Adaptec Customer Support
 
    A Technical Support Identification (TSID) Number is required for 
    Adaptec technical support.
     - The 12-digit TSID can be found on the white barcode-type label
-      included inside the box with your product. The TSID helps us 
+      included inside the box with your product.  The TSID helps us 
       provide more efficient service by accurately identifying your 
       product and support status.
+
    Support Options
     - Search the Adaptec Support Knowledgebase (ASK) at
       http://ask.adaptec.com for articles, troubleshooting tips, and
-      frequently asked questions for your product.
+      frequently asked questions about your product.
     - For support via Email, submit your question to Adaptec's 
-      Technical Support Specialists at http://ask.adaptec.com.
+      Technical Support Specialists at http://ask.adaptec.com/.
      
    North America
-    - Visit our Web site at http://www.adaptec.com.
-    - To speak with a Fibre Channel/RAID/External Storage Technical
-      Support Specialist, call 1-321-207-2000,
-      Hours: Monday-Friday, 3:00 A.M. to 5:00 P.M., PST.
-      (Not open on holidays)
-    - For Technical Support in all other technologies including 
-      SCSI, call 1-408-934-7274,
-      Hours: Monday-Friday, 6:00 A.M. to 5:00 P.M., PST.
-      (Not open on holidays)
-    - For after hours support, call 1-800-416-8066 ($99/call, 
-      $149/call on holidays)
-    - To order Adaptec products including software and cables, call
-      1-800-442-7274 or 1-408-957-7274. You can also visit our 
-      online store at http://www.adaptecstore.com
+    - Visit our Web site at http://www.adaptec.com/.
+    - For information about Adaptec's support options, call
+      408-957-2550, 24 hours a day, 7 days a week.
+    - To speak with a Technical Support Specialist,
+      * For hardware products, call 408-934-7274,
+        Monday to Friday, 3:00 am to 5:00 pm, PDT.
+      * For RAID and Fibre Channel products, call 321-207-2000,
+        Monday to Friday, 3:00 am to 5:00 pm, PDT.
+      To expedite your service, have your computer with you.
+    - To order Adaptec products, including accessories and cables,
+      call 408-957-7274.  To order cables online go to
+      http://www.adaptec.com/buy-cables/.
 
    Europe
-    - Visit our Web site at http://www.adaptec-europe.com.
-    - English and French: To speak with a Technical Support 
-      Specialist, call one of the following numbers:
-        - English: +32-2-352-3470
-        - French:  +32-2-352-3460
-      Hours: Monday-Thursday, 10:00 to 12:30, 13:30 to 17:30 CET 
-             Friday, 10:00 to 12:30, 13:30 to 16:30 CET
-    - German: To speak with a Technical Support Specialist,
-      call +49-89-456-40660
-      Hours: Monday-Thursday, 09:30 to 12:30, 13:30 to 16:30 CET
-             Friday, 09:30 to 12:30, 13:30 to 15:00 CET
-    - To order Adaptec products, including accessories and cables:
-        - UK: +0800-96-65-26 or fax +0800-731-02-95
-        - Other European countries: +32-11-300-379
-
-   Australia and New Zealand
-    - Visit our Web site at http://www.adaptec.com.au.
-    - To speak with a Technical Support Specialist, call 
-      +612-9416-0698
-      Hours: Monday-Friday, 10:00 A.M. to 4:30 P.M., EAT
-      (Not open on holidays)
+    - Visit our Web site at http://www.adaptec-europe.com/.
+    - To speak with a Technical Support Specialist, call, or email,
+      * German:  +49 89 4366 5522, Monday-Friday, 9:00-17:00 CET,
+        http://ask-de.adaptec.com/.
+      * French:  +49 89 4366 5533, Monday-Friday, 9:00-17:00 CET,
+	http://ask-fr.adaptec.com/.
+      * English: +49 89 4366 5544, Monday-Friday, 9:00-17:00 GMT,
+	http://ask.adaptec.com/.
+    - You can order Adaptec cables online at
+      http://www.adaptec.com/buy-cables/.
 
    Japan
+    - Visit our web site at http://www.adaptec.co.jp/.
     - To speak with a Technical Support Specialist, call 
-      +81-3-5308-6120 
-      Hours: Monday-Friday, 9:00 a.m. to 12:00 p.m., 1:00 p.m. to
-      6:00 p.m. TSC
-
-   Hong Kong and China
-    - To speak with a Technical Support Specialist, call 
-      +852-2869-7200
-      Hours: Monday-Friday, 10:00 to 17:00.
-    - Fax Technical Support at +852-2869-7100.
-
-   Singapore
-    - To speak with a Technical Support Specialist, call 
-      +65-245-7470
-      Hours: Monday-Friday, 10:00 to 17:00.
-    - Fax Technical Support at +852-2869-7100
+      +81 3 5308 6120, Monday-Friday, 9:00 a.m. to 12:00 p.m.,
+      1:00 p.m. to 6:00 p.m.
 
 -------------------------------------------------------------------
 /*

--------------060906010607020500030609--
