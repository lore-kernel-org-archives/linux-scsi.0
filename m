From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 2/8]  fusion - mptctl - adding support for bus_type=SAS
Date: Thu, 2 Feb 2006 17:19:33 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F243696@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C62857.824BF41B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4504 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751196AbWBCATf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2006 19:19:35 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k130EGNI021724
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:14:16 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k130JY4e026610
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:19:34 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C62857.824BF41B
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Add bus_type recognization in ioctl path for SAS.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_001_01C62857.824BF41B
Content-Type: application/octet-stream;
	name="2-sas-names.patch"
Content-Transfer-Encoding: base64
Content-Description: 2-sas-names.patch
Content-Disposition: attachment;
	filename="2-sas-names.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0Y3RsLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdGN0bC5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0Y3Rs
LmMJMjAwNi0wMi0wMiAxNDozNTo0NS4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRjdGwuYwkyMDA2LTAyLTAyIDE0OjU5OjAzLjAwMDAwMDAwMCAtMDcwMApA
QCAtMTE0NSw3ICsxMTQ1LDkgQEAKIAkvKiBGaWxsIGluIHRoZSBkYXRhIGFuZCByZXR1cm4gdGhl
IHN0cnVjdHVyZSB0byB0aGUgY2FsbGluZwogCSAqIHByb2dyYW0KIAkgKi8KLQlpZiAoaW9jLT5i
dXNfdHlwZSA9PSBGQykKKwlpZiAoaW9jLT5idXNfdHlwZSA9PSBTQVMpCisJCWthcmctPmFkYXB0
ZXJUeXBlID0gTVBUX0lPQ1RMX0lOVEVSRkFDRV9TQVM7CisJZWxzZSBpZiAoaW9jLT5idXNfdHlw
ZSA9PSBGQykKIAkJa2FyZy0+YWRhcHRlclR5cGUgPSBNUFRfSU9DVExfSU5URVJGQUNFX0ZDOwog
CWVsc2UKIAkJa2FyZy0+YWRhcHRlclR5cGUgPSBNUFRfSU9DVExfSU5URVJGQUNFX1NDU0k7CkBA
IC0yMzkxLDcgKzIzOTMsNyBAQAogCiAJa2FyZy5iYXNlX2lvX2FkZHIgPSBwY2lfcmVzb3VyY2Vf
c3RhcnQocGRldiwgMCk7CiAKLQlpZiAoaW9jLT5idXNfdHlwZSA9PSBGQykKKwlpZiAoKGlvYy0+
YnVzX3R5cGUgPT0gU0FTKSB8fCAoaW9jLT5idXNfdHlwZSA9PSBGQykpCiAJCWthcmcuYnVzX3Bo
eXNfd2lkdGggPSBIUF9CVVNfV0lEVEhfVU5LOwogCWVsc2UKIAkJa2FyZy5idXNfcGh5c193aWR0
aCA9IEhQX0JVU19XSURUSF8xNjsKQEAgLTI0ODAsNyArMjQ4Miw3IEBACiAKIAkvKiAgVGhlcmUg
aXMgbm90aGluZyB0byBkbyBmb3IgRkNQIHBhcnRzLgogCSAqLwotCWlmIChpb2MtPmJ1c190eXBl
ID09IEZDKQorCWlmICgoaW9jLT5idXNfdHlwZSA9PSBTQVMpIHx8IChpb2MtPmJ1c190eXBlID09
IEZDKSkKIAkJcmV0dXJuIDA7CiAKIAlpZiAoKGlvYy0+c3BpX2RhdGEuc2RwMGxlbmd0aCA9PSAw
KSB8fCAoaW9jLT5zaCA9PSBOVUxMKSkKZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNp
b24vbXB0Y3RsLmggYS9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21wdGN0bC5oCi0tLSBiL2RyaXZl
cnMvbWVzc2FnZS9mdXNpb24vbXB0Y3RsLmgJMjAwNi0wMS0wMiAyMDoyMToxMC4wMDAwMDAwMDAg
LTA3MDAKKysrIGEvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9tcHRjdGwuaAkyMDA2LTAyLTAyIDE0
OjU0OjQzLjAwMDAwMDAwMCAtMDcwMApAQCAtMTY5LDggKzE2OSwxMCBAQAogICogIFJlYWQgb25s
eS4KICAqICBEYXRhIHN0YXJ0cyBhdCBvZmZzZXQgMHhDCiAgKi8KLSNkZWZpbmUgTVBUX0lPQ1RM
X0lOVEVSRkFDRV9GQwkJKDB4MDEpCiAjZGVmaW5lIE1QVF9JT0NUTF9JTlRFUkZBQ0VfU0NTSQko
MHgwMCkKKyNkZWZpbmUgTVBUX0lPQ1RMX0lOVEVSRkFDRV9GQwkJKDB4MDEpCisjZGVmaW5lIE1Q
VF9JT0NUTF9JTlRFUkZBQ0VfRkNfSVAJKDB4MDIpCisjZGVmaW5lIE1QVF9JT0NUTF9JTlRFUkZB
Q0VfU0FTCQkoMHgwMykKICNkZWZpbmUgTVBUX0lPQ1RMX1ZFUlNJT05fTEVOR1RICSgzMikKIAog
c3RydWN0IG1wdF9pb2N0bF9pb2NpbmZvIHsK

------_=_NextPart_001_01C62857.824BF41B--
