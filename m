From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/3] megaraid_sas: Fix FastPath I/O to work on degraded raid 1
Date: Tue, 26 Jul 2011 16:16:40 -0700
Message-ID: <CAHtARFENmgkmNuGcJq3d1zRr3TOwPq-t_F5y2hZjVLdapEc5xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd56b44d1dc8d04a9011f57
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52432 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1GZXQl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 19:16:41 -0400
Received: by iyb12 with SMTP id 12so1011454iyb.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2011 16:16:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--000e0cd56b44d1dc8d04a9011f57
Content-Type: text/plain; charset=ISO-8859-1

(Re-sent to fix subject line to add megaraid_sas)

James/linux-scsi,

This patch for megaraid_sas fixes FastPath I/O to work on degraded raid 1.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fp.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fp.c	2011-07-21
19:17:23.000000000 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c	2011-07-26
14:13:15.518247693 -0700
@@ -288,7 +288,6 @@
 				/* Get dev handle from Pd */
 				*pDevHandle = MR_PdDevHandleGet(pd, map);
 		}
-		retval = FALSE;
 	}

 	*pdBlock += stripRef + MR_LdSpanPtrGet(ld, span, map)->startBlk;

--000e0cd56b44d1dc8d04a9011f57
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqlhfdzo0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
cC5jIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5j
Ci0tLSBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jCTIw
MTEtMDctMjEgMTk6MTc6MjMuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnAuYwkyMDExLTA3LTI2IDE0OjEzOjE1LjUx
ODI0NzY5MyAtMDcwMApAQCAtMjg4LDcgKzI4OCw2IEBACiAJCQkJLyogR2V0IGRldiBoYW5kbGUg
ZnJvbSBQZCAqLwogCQkJCSpwRGV2SGFuZGxlID0gTVJfUGREZXZIYW5kbGVHZXQocGQsIG1hcCk7
CiAJCX0KLQkJcmV0dmFsID0gRkFMU0U7CiAJfQogCiAJKnBkQmxvY2sgKz0gc3RyaXBSZWYgKyBN
Ul9MZFNwYW5QdHJHZXQobGQsIHNwYW4sIG1hcCktPnN0YXJ0QmxrOwo=
--000e0cd56b44d1dc8d04a9011f57--
