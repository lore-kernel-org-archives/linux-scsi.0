From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] include/scsi/scsi.h replace u8 in 2.5.69
Date: Wed, 14 May 2003 16:39:43 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC1E4AF.6040404@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010200020100000304090909"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:56849 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262282AbTENG00
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 02:26:26 -0400
Received: from torque.net (d-241-253.stlucia.uq.net.au [203.101.241.253])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h4E6d8HO007192
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2003 16:39:10 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010200020100000304090909
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Here is a simple patch to replace the single occurrence
of "u8" with "u_char" in include/scsi/scsi.h .

While working on an application (to test sgbind) that
needs to include the kernel rather than the glibc
headers, it is a nuisance to have to add:
    typedef unsigned char u8;
before including /usr/src/linux/include/scsi/scsi.h

Perhaps we should be moving toward the official C99
typedef: uint8_t which is defined in stdint.h

Doug Gilbert

--------------010200020100000304090909
Content-Type: text/plain;
 name="scsi_h_2569.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_h_2569.diff"

--- linux/include/scsi/scsi.h	2003-02-11 08:39:21.000000000 +1000
+++ linux/include/scsi/scsi.h2569fix	2003-05-14 12:41:48.000000000 +1000
@@ -201,7 +201,7 @@
  * ScsiLun: 8 byte LUN.
  */
 typedef struct scsi_lun {
-	u8 scsi_lun[8];
+	u_char scsi_lun[8];
 } ScsiLun;
 
 /*

--------------010200020100000304090909--

