From: guru <guru@computer-rave.com>
Subject: u8 to __u8
Date: Thu, 25 Feb 2010 18:50:26 -0700
Message-ID: <4B8728E2.7060707@computer-rave.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000508090609070707090703"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from defout.telus.net ([204.209.205.55]:53409 "EHLO defout.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934980Ab0BZB75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Feb 2010 20:59:57 -0500
Received: from edmwaa01.telusplanet.net ([206.75.56.140])
          by priv-edmwes74.telusplanet.net
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20100226014456.XDAL14322.priv-edmwes74.telusplanet.net@edmwaa01.telusplanet.net>
          for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2010 18:44:56 -0700
Received: from [192.168.1.2] (d206-75-56-140.abhsia.telus.net [206.75.56.140])
	by edmwaa01.telusplanet.net (BorderWare Security Platform) with ESMTP id 90B71264AF8B4E34
	for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2010 18:44:55 -0700 (MST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000508090609070707090703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

HI
It looks like the imclude/scsi/scsi.h needs u8 changed to __u8

Take care
oneforall
Brain

--------------000508090609070707090703
Content-Type: text/plain;
 name="linux-2.6.33-scsi.h-u8-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linux-2.6.33-scsi.h-u8-fix.diff"

--- linux-2.6.33/include/scsi/scsi.h.org	2010-02-24 11:52:17.000000000 -0700
+++ linux-2.6.33/include/scsi/scsi.h	2010-02-25 18:40:19.930379908 -0700
@@ -149,10 +149,10 @@
 
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
-	u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
-	u8 control;
-	u8 misc[5];
-	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always == VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };

--------------000508090609070707090703--
