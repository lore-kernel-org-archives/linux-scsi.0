From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] sym53c8xx_2: Use standard command-names
Date: Sun, 5 Sep 2004 22:27:40 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409052225100.2062@poirot.grange>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811839-630274484-1094416060=:2062"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:61886 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267470AbUIFFuu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 01:50:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811839-630274484-1094416060=:2062
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

Hi

A trivial patch to use standard names for INQUIRY and TEST_UNIT_READY.

Thanks
Guennadi
---
Guennadi Liakhovetski

---1463811839-630274484-1094416060=:2062
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="sym53c8xx_2-cmdnames.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.60.0409052227400.2062@poirot.grange>
Content-Description: 
Content-Disposition: attachment; filename="sym53c8xx_2-cmdnames.patch"

VXNlIHN0YW5kYXJkIGNvbW1hbmQtbmFtZXMuDQoNClNpZ25lZC1vZmYtYnk6
IEd1ZW5uYWRpIExpYWtob3ZldHNraSA8Zy5saWFraG92ZXRza2lAZ214LmRl
Pg0KDQpkaWZmIC11IGEvZHJpdmVycy9zY3NpL3N5bTUzYzh4eF8yL3N5bV9n
bHVlLmMgYi9kcml2ZXJzL3Njc2kvc3ltNTNjOHh4XzIvc3ltX2dsdWUuYw0K
LS0tIGEvZHJpdmVycy9zY3NpL3N5bTUzYzh4eF8yL3N5bV9nbHVlLmMJMTcg
QXVnIDIwMDQgMjA6MzQ6NTgNCisrKyBiL2RyaXZlcnMvc2NzaS9zeW01M2M4
eHhfMi9zeW1fZ2x1ZS5jCTUgU2VwIDIwMDQgMjA6MTk6NDUNCkBAIC01MzYs
NyArNTM2LDcgQEANCiAJICogIGRldmljZXMgYmVoYXZlIGJhZGx5IHdoZW4g
YXNrZWQgZm9yIHNvbWUgbm9uIA0KIAkgKiAgemVybyBMVU4uIEJ0dywgdGhp
cyBpcyBhbiBhYnNvbHV0ZSBoYWNrLjotKQ0KIAkgKi8NCi0JaWYgKGNjYi0+
Y21uZFswXSA9PSAweDEyIHx8IGNjYi0+Y21uZFswXSA9PSAweDApIHsNCisJ
aWYgKGNjYi0+Y21uZFswXSA9PSBJTlFVSVJZIHx8IGNjYi0+Y21uZFswXSA9
PSBURVNUX1VOSVRfUkVBRFkpIHsNCiAJCWlmICgodHAtPnVzcmZsYWdzICYg
U1lNX1NDQU5fQk9PVF9ESVNBQkxFRCkgfHwNCiAJCSAgICAoKHRwLT51c3Jm
bGFncyAmIFNZTV9TQ0FOX0xVTlNfRElTQUJMRUQpICYmIA0KIAkJICAgICBj
Y2ItPmRldmljZS0+bHVuICE9IDApKSB7DQo=

---1463811839-630274484-1094416060=:2062--
