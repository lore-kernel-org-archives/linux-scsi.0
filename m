From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] rm unused scan delay var
Date: Fri, 25 Mar 2005 22:16:19 -0800
Message-ID: <4244FE33.8030004@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060404040601080008050601"
Received: from sabe.cs.wisc.edu ([128.105.6.20]:6808 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262014AbVCZGQJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Mar 2005 01:16:09 -0500
Received: from [192.168.0.2] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j2Q6G7Gf010160
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 26 Mar 2005 00:16:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060404040601080008050601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Is FC_SCSI_SCAN_DELAY used by a FC driver that is
not yet in mainline? This patch just deletes it
if not since no one else is.

Signed-off-by: Mike Chrisite <michaelc@cs.wisc.edu>

--------------060404040601080008050601
Content-Type: text/x-patch;
 name="rm-unused-scan-delay.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rm-unused-scan-delay.patch"

--- scsi-misc-2.6.orig/include/scsi/scsi_transport_fc.h	2005-03-25 21:35:06.000000000 -0800
+++ scsi-misc-2.6.test/include/scsi/scsi_transport_fc.h	2005-03-25 22:01:49.000000000 -0800
@@ -212,9 +212,6 @@ struct fc_rport {	/* aka fc_starget_attr
 #define rport_to_shost(r)			\
 	dev_to_shost(r->dev.parent)
 
-#define FC_SCSI_SCAN_DELAY		(1 * HZ)	/* 1 second delay */
-
-
 /*
  * FC SCSI Target Attributes
  *

--------------060404040601080008050601--
