From: adam radford <aradford@gmail.com>
Subject: [PATCH 9/14] megaraid_sas: Add CFG_CLEARED AEN
Date: Thu, 24 Feb 2011 20:56:53 -0800
Message-ID: <AANLkTikBT0BbWeAJMeSD9RDSn8Hf8qJzrWXa_uyhP5ea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016364269dfa52808049d1428c3
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49097 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1BYE4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:56:54 -0500
Received: by mail-ww0-f44.google.com with SMTP id 39so1696373wwb.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:56:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016364269dfa52808049d1428c3
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas adds a missing check for
MR_EVT_CFG_CLEARED in megasas_aen_polling().

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:50:26.822306902 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:55:01.467276376 -0800
@@ -5197,6 +5197,7 @@
 			break;

 		case MR_EVT_LD_OFFLINE:
+		case MR_EVT_CFG_CLEARED:
 		case MR_EVT_LD_DELETED:
 			megasas_get_ld_list(instance);
 			for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {

--0016364269dfa52808049d1428c3
Content-Type: application/octet-stream; name="megaraid_sas.patch9"
Content-Disposition: attachment; filename="megaraid_sas.patch9"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmk5dj0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTg6NTA6MjYuODIyMzA2OTAyIC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE4OjU1OjAxLjQ2NzI3NjM3NiAtMDgwMApAQCAtNTE5Nyw2ICs1MTk3LDcg
QEAKIAkJCWJyZWFrOwogCiAJCWNhc2UgTVJfRVZUX0xEX09GRkxJTkU6CisJCWNhc2UgTVJfRVZU
X0NGR19DTEVBUkVEOgogCQljYXNlIE1SX0VWVF9MRF9ERUxFVEVEOgogCQkJbWVnYXNhc19nZXRf
bGRfbGlzdChpbnN0YW5jZSk7CiAJCQlmb3IgKGkgPSAwOyBpIDwgTUVHQVNBU19NQVhfTERfQ0hB
Tk5FTFM7IGkrKykgewo=
--0016364269dfa52808049d1428c3--
