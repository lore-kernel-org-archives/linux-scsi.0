From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/3] Fix FastPath I/O to work on degraded raid 1
Date: Tue, 26 Jul 2011 15:42:39 -0700
Message-ID: <CAHtARFH=zsegu_Wu_RsMEGpVxWbL-FRSb2VZwQjq-e39O34-rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd4a61c22dfbb04a900a6bc
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44068 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1GZWmj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 18:42:39 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so982773iyb.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2011 15:42:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--000e0cd4a61c22dfbb04a900a6bc
Content-Type: text/plain; charset=ISO-8859-1

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

--000e0cd4a61c22dfbb04a900a6bc
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqlef65i0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
cC5jIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5j
Ci0tLSBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jCTIw
MTEtMDctMjEgMTk6MTc6MjMuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnAuYwkyMDExLTA3LTI2IDE0OjEzOjE1LjUx
ODI0NzY5MyAtMDcwMApAQCAtMjg4LDcgKzI4OCw2IEBACiAJCQkJLyogR2V0IGRldiBoYW5kbGUg
ZnJvbSBQZCAqLwogCQkJCSpwRGV2SGFuZGxlID0gTVJfUGREZXZIYW5kbGVHZXQocGQsIG1hcCk7
CiAJCX0KLQkJcmV0dmFsID0gRkFMU0U7CiAJfQogCiAJKnBkQmxvY2sgKz0gc3RyaXBSZWYgKyBN
Ul9MZFNwYW5QdHJHZXQobGQsIHNwYW4sIG1hcCktPnN0YXJ0QmxrOwo=
--000e0cd4a61c22dfbb04a900a6bc--
