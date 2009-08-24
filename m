From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH] scsi_dh_rdac: Fix for returning correct mode select return
 info
Date: Mon, 24 Aug 2009 17:29:36 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474BFD8F8@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:59687 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbZHXX3m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2009 19:29:42 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Chandra Seetharaman <sekharan@us.ibm.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

VGhpcyBwYXRjaCBmaXhlcyB0aGUgcHJvYmxlbSB3aXRoIG1vZGVfc2VsZWN0X2hhbmRsZV9zZW5z
ZSB3aGVuIHJldHVuaW5nIG1vZGUgc2VsZWN0IGNvbXBsZXRpb24gc3RhdHVzLiBJIGhhdmUgcmVt
b3ZlZCB0aGUgZGVmYXVsdCBpbml0aWFsaXphdGlvbiBvZiByZXR1cm4gY29kZSB0byBTQ1NJX0RI
X09LLiBOb3cgaXQgaXMgaW5pdGlhbGl6ZWQgdG8gIFNDU0lfREhfSU8uDQogDQpTaWduZWQtb2Zm
LWJ5OiBCYWJ1IE1vZ2VyIDxiYWJ1Lm1vZ2VyQGxzaS5jb20+DQoNCi0tLQ0KLS0tIGxpbnV4LTIu
Ni4zMS1yYzUvZHJpdmVycy9zY3NpL2RldmljZV9oYW5kbGVyL3Njc2lfZGhfcmRhYy5jLm9yaWcJ
MjAwOS0wOC0yMiAwNjoyMDo0NS4wMDAwMDAwMDAgLTA1MDANCisrKyBsaW51eC0yLjYuMzEtcmM1
L2RyaXZlcnMvc2NzaS9kZXZpY2VfaGFuZGxlci9zY3NpX2RoX3JkYWMuYwkyMDA5LTA4LTIyIDA2
OjE4OjM2LjAwMDAwMDAwMCAtMDUwMA0KQEAgLTQ1NSw4ICs0NTUsNiBAQCBzdGF0aWMgaW50IG1v
ZGVfc2VsZWN0X2hhbmRsZV9zZW5zZShzdHJ1DQogCWlmICghcmV0KQ0KIAkJZ290byBkb25lOw0K
IA0KLQllcnIgPSBTQ1NJX0RIX09LOw0KLQ0KIAlzd2l0Y2ggKHNlbnNlX2hkci5zZW5zZV9rZXkp
IHsNCiAJY2FzZSBOT19TRU5TRToNCiAJY2FzZSBBQk9SVEVEX0NPTU1BTkQ6DQoNCg0K
