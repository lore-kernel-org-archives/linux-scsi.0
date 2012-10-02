From: adam radford <aradford@gmail.com>
Subject: [PATCH 5/7] megaraid_sas: Add SystemPD FastPath support
Date: Mon, 1 Oct 2012 19:27:20 -0700
Message-ID: <CAHtARFEx49_Uh-jH5UzTDfy5o5W5pHHx3Y8Lk4mn_iDpnD=3Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7bf0f14ef0dcee04cb0a42b2
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48158 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751Ab2JBC1U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 22:27:20 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so6100886vbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Oct 2012 19:27:20 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--047d7bf0f14ef0dcee04cb0a42b2
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds SystemPD FastPath support.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
17:07:36.228925449 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
17:09:12.628956305 -0700
@@ -1524,6 +1524,8 @@
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
 			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+		cmd->request_desc->SCSIIO.DevHandle =
+			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
 	} else {
 		io_request->Function  = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
 		io_request->DevHandle = device_id;

--047d7bf0f14ef0dcee04cb0a42b2
Content-Type: application/octet-stream; name="megaraid_sas.patch5"
Content-Disposition: attachment; filename="megaraid_sas.patch5"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19m
dXNpb24uYyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNf
ZnVzaW9uLmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTItMTAtMDEgMTc6MDc6MzYuMjI4OTI1NDQ5IC0wNzAwCisrKyBzY3NpLW1p
c2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMi0x
MC0wMSAxNzowOToxMi42Mjg5NTYzMDUgLTA3MDAKQEAgLTE1MjQsNiArMTUyNCw4IEBACiAJCWNt
ZC0+cmVxdWVzdF9kZXNjLT5TQ1NJSU8uUmVxdWVzdEZsYWdzID0KIAkJCShNUEkyX1JFUV9ERVND
UklQVF9GTEFHU19ISUdIX1BSSU9SSVRZIDw8CiAJCQkgTUVHQVNBU19SRVFfREVTQ1JJUFRfRkxB
R1NfVFlQRV9TSElGVCk7CisJCWNtZC0+cmVxdWVzdF9kZXNjLT5TQ1NJSU8uRGV2SGFuZGxlID0K
KwkJCWxvY2FsX21hcF9wdHItPnJhaWRNYXAuZGV2SG5kbEluZm9bZGV2aWNlX2lkXS5jdXJEZXZI
ZGw7CiAJfSBlbHNlIHsKIAkJaW9fcmVxdWVzdC0+RnVuY3Rpb24gID0gTUVHQVNBU19NUEkyX0ZV
TkNUSU9OX0xEX0lPX1JFUVVFU1Q7CiAJCWlvX3JlcXVlc3QtPkRldkhhbmRsZSA9IGRldmljZV9p
ZDsK
--047d7bf0f14ef0dcee04cb0a42b2--
