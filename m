From: adam radford <aradford@gmail.com>
Subject: [PATCH 10/15] megaraid_sas: Add CFG_CLEARED AEN
Date: Sat, 19 Feb 2011 18:23:05 -0800
Message-ID: <AANLkTikL8UCXF790+8cej1oDfeW8onDdgzFAK-cpL9Kq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e65b52a66100a3049cad6d4a
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50704 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCXF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:23:05 -0500
Received: by mail-wy0-f174.google.com with SMTP id 38so105867wyb.19
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:23:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e65b52a66100a3049cad6d4a
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas adds a missing check for
MR_EVT_CFG_CLEARED in megasas_aen_polling().

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:09:36.091395007 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:17:06.059207416 -0800
@@ -5201,6 +5201,7 @@
 			break;

 		case MR_EVT_LD_OFFLINE:
+		case MR_EVT_CFG_CLEARED:
 		case MR_EVT_LD_DELETED:
 			megasas_get_ld_list(instance);
 			for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {

--0016e65b52a66100a3049cad6d4a
Content-Type: application/octet-stream; name="megaraid_sas.patch10"
Content-Disposition: attachment; filename="megaraid_sas.patch10"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdba9v90

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTQ6MDk6MzYuMDkxMzk1MDA3IC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDE0OjE3OjA2LjA1OTIwNzQxNiAtMDgwMApAQCAtNTIw
MSw2ICs1MjAxLDcgQEAKIAkJCWJyZWFrOwogCiAJCWNhc2UgTVJfRVZUX0xEX09GRkxJTkU6CisJ
CWNhc2UgTVJfRVZUX0NGR19DTEVBUkVEOgogCQljYXNlIE1SX0VWVF9MRF9ERUxFVEVEOgogCQkJ
bWVnYXNhc19nZXRfbGRfbGlzdChpbnN0YW5jZSk7CiAJCQlmb3IgKGkgPSAwOyBpIDwgTUVHQVNB
U19NQVhfTERfQ0hBTk5FTFM7IGkrKykgewo=
--0016e65b52a66100a3049cad6d4a--
