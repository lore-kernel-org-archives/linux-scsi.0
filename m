From: Linda Xie <lxiep@us.ibm.com>
Subject: [PATCH] scsi/ibmvscsi/srp.h: Fix a wrong type code used for SRP_LOGIN_REJ
Date: Fri, 15 Jul 2005 17:49:27 -0500
Message-ID: <42D83D77.4030107@us.ibm.com>
Reply-To: lxiep@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070108040303040003060809"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:52165 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262043AbVGOXY7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2005 19:24:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Dave C Boutcher <sleddog@us.ibm.com>, linux-kernel@vger.kernel.org, Santiago Leon <santil@us.ibm.com>

This is a multi-part message in MIME format.
--------------070108040303040003060809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi James,

This patch fixes srp.h which uses 0x80 for SRP_LOGIN_REJ instead of 
0xc2.  Please apply.

Thanks,

Linda

Signed-off-by: Linda Xie <lxie@us.ibm.com

--------------070108040303040003060809
Content-Type: text/plain;
 name="srp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp.patch"

diff -X ../dontdiff -purN large-sg/drivers/scsi/ibmvscsi/srp.h srp/drivers/scsi/ibmvscsi/srp.h
--- large-sg/drivers/scsi/ibmvscsi/srp.h	2005-06-24 17:32:27.000000000 -0500
+++ srp/drivers/scsi/ibmvscsi/srp.h	2005-07-15 17:36:45.000000000 -0500
@@ -35,7 +35,7 @@
 enum srp_types {
 	SRP_LOGIN_REQ_TYPE = 0x00,
 	SRP_LOGIN_RSP_TYPE = 0xC0,
-	SRP_LOGIN_REJ_TYPE = 0x80,
+	SRP_LOGIN_REJ_TYPE = 0xC2,
 	SRP_I_LOGOUT_TYPE = 0x03,
 	SRP_T_LOGOUT_TYPE = 0x80,
 	SRP_TSK_MGMT_TYPE = 0x01,

--------------070108040303040003060809--

