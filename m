From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/10] megaraid_sas: Increase default cmds per lun to 256
Date: Sat, 8 Oct 2011 18:14:33 -0700
Message-ID: <CAHtARFGRRaobHK6eSf1L2OyGRHE5DQhCEr0mLwBneB0hOY_DhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e65c8ddaa4c2d204aed365b9
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63151 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBOe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:14:34 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so7565389wwf.1
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:14:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e65c8ddaa4c2d204aed365b9
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

This patch for megaraid_sas will increase the default cmds_per_lun
from 128 to 256.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-10-07
12:10:42.000000000 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-10-07
17:40:10.150331448 -0700
@@ -716,7 +716,7 @@
 #define MEGASAS_DEFAULT_INIT_ID			-1
 #define MEGASAS_MAX_LUN				8
 #define MEGASAS_MAX_LD				64
-#define MEGASAS_DEFAULT_CMD_PER_LUN		128
+#define MEGASAS_DEFAULT_CMD_PER_LUN		256
 #define MEGASAS_MAX_PD                          (MEGASAS_MAX_PD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)
 #define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \

--0016e65c8ddaa4c2d204aed365b9
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjbqgmf0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXMuaCBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
LmgKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5o
CTIwMTEtMTAtMDcgMTI6MTA6NDIuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MtMi42Lm5l
dy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMS0xMC0wNyAxNzo0MDox
MC4xNTAzMzE0NDggLTA3MDAKQEAgLTcxNiw3ICs3MTYsNyBAQAogI2RlZmluZSBNRUdBU0FTX0RF
RkFVTFRfSU5JVF9JRAkJCS0xCiAjZGVmaW5lIE1FR0FTQVNfTUFYX0xVTgkJCQk4CiAjZGVmaW5l
IE1FR0FTQVNfTUFYX0xECQkJCTY0Ci0jZGVmaW5lIE1FR0FTQVNfREVGQVVMVF9DTURfUEVSX0xV
TgkJMTI4CisjZGVmaW5lIE1FR0FTQVNfREVGQVVMVF9DTURfUEVSX0xVTgkJMjU2CiAjZGVmaW5l
IE1FR0FTQVNfTUFYX1BEICAgICAgICAgICAgICAgICAgICAgICAgICAoTUVHQVNBU19NQVhfUERf
Q0hBTk5FTFMgKiBcCiAJCQkJCQlNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5ORUwpCiAjZGVmaW5l
IE1FR0FTQVNfTUFYX0xEX0lEUwkJCShNRUdBU0FTX01BWF9MRF9DSEFOTkVMUyAqIFwK
--0016e65c8ddaa4c2d204aed365b9--
