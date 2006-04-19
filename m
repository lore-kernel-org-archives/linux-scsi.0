From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] - mpt fusion - mptspi - host reset, kick off domainvalidation again.
Date: Wed, 19 Apr 2006 15:14:44 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D700813E8@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C663F6.4812D2E5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38128 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751243AbWDSVOr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 17:14:47 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C663F6.4812D2E5
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Wednesday, April 19, 2006 1:36 PM, James Bottomley wrote: =20
>=20
> The equivalent of this check is *already* in=20
> mptspi_dv_device(), so you
> don't need to check it again.  Simply replacing=20
> mptspi_renegotiate with
> mptspi_dv_device() should work fine.
>=20

Yes, your right. Thanks for seeing that.  I've fix'd that
up, and attached is the new patch.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C663F6.4812D2E5
Content-Type: application/octet-stream;
	name="spi_dv_fix.patch"
Content-Transfer-Encoding: base64
Content-Description: spi_dv_fix.patch
Content-Disposition: attachment;
	filename="spi_dv_fix.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c3BpLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdHNwaS5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c3Bp
LmMJMjAwNi0wNC0xNyAxMDozMzo1MC4wMDAwMDAwMDAgLTA2MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRzcGkuYwkyMDA2LTA0LTE5IDE1OjA4OjExLjAwMDAwMDAwMCAtMDYwMApA
QCAtNzgzLDYgKzc4Myw0NCBAQAogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCBtcHRzcGlf
cGNpX3RhYmxlKTsKIAorLyoKKyAqIHNwaSBtb2R1bGUgcmVzZXQgaGFuZGxlcgorICovCitzdGF0
aWMgaW50CittcHRzcGlfaW9jX3Jlc2V0KE1QVF9BREFQVEVSICppb2MsIGludCByZXNldF9waGFz
ZSkKK3sKKwlzdHJ1Y3QgX01QVF9TQ1NJX0hPU1QgKmhkID0gKHN0cnVjdCBfTVBUX1NDU0lfSE9T
VCAqKWlvYy0+c2gtPmhvc3RkYXRhOworCXN0cnVjdCBzY3NpX2RldmljZSAqc2RldjsKKwlpbnQg
cmM7CisKKwlyYyA9IG1wdHNjc2loX2lvY19yZXNldChpb2MsIHJlc2V0X3BoYXNlKTsKKworCWlm
IChyZXNldF9waGFzZSA9PSBNUFRfSU9DX1BPU1RfUkVTRVQpCisJCXNob3N0X2Zvcl9lYWNoX2Rl
dmljZShzZGV2LCBpb2MtPnNoKQorCQkJbXB0c3BpX2R2X2RldmljZShoZCwgc2Rldik7CisKKwly
ZXR1cm4gcmM7Cit9CisKKy8qCisgKiBzcGkgbW9kdWxlIHJlc3VtZSBoYW5kbGVyCisgKi8KK3N0
YXRpYyBpbnQKK21wdHNwaV9yZXN1bWUoc3RydWN0IHBjaV9kZXYgKnBkZXYpCit7CisJTVBUX0FE
QVBURVIgCSppb2MgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7CisJc3RydWN0IF9NUFRfU0NTSV9I
T1NUICpoZCA9IChzdHJ1Y3QgX01QVF9TQ1NJX0hPU1QgKilpb2MtPnNoLT5ob3N0ZGF0YTsKKyAg
ICAgICAgc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2OworCWludCByYzsKKworCXJjID0gbXB0c2Nz
aWhfcmVzdW1lKHBkZXYpOworCisJc2hvc3RfZm9yX2VhY2hfZGV2aWNlKHNkZXYsIGlvYy0+c2gp
CisJCW1wdHNwaV9kdl9kZXZpY2UoaGQsIHNkZXYpOworCisJcmV0dXJuIHJjOworfQorCiAvKj0t
PS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09
LT0tPS09LT0tPS09LT0tPSovCiAvKj0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09
LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPSovCiAvKgpAQCAtMTAzMiw3
ICsxMDcwLDcgQEAKIAkuc2h1dGRvd24JPSBtcHRzY3NpaF9zaHV0ZG93biwKICNpZmRlZiBDT05G
SUdfUE0KIAkuc3VzcGVuZAk9IG1wdHNjc2loX3N1c3BlbmQsCi0JLnJlc3VtZQkJPSBtcHRzY3Np
aF9yZXN1bWUsCisJLnJlc3VtZQkJPSBtcHRzcGlfcmVzdW1lLAogI2VuZGlmCiB9OwogCkBAIC0x
MDYxLDcgKzEwOTksNyBAQAogCQkgICI6IFJlZ2lzdGVyZWQgZm9yIElPQyBldmVudCBub3RpZmlj
YXRpb25zXG4iKSk7CiAJfQogCi0JaWYgKG1wdF9yZXNldF9yZWdpc3RlcihtcHRzcGlEb25lQ3R4
LCBtcHRzY3NpaF9pb2NfcmVzZXQpID09IDApIHsKKwlpZiAobXB0X3Jlc2V0X3JlZ2lzdGVyKG1w
dHNwaURvbmVDdHgsIG1wdHNwaV9pb2NfcmVzZXQpID09IDApIHsKIAkJZHByaW50aygoS0VSTl9J
TkZPIE1ZTkFNCiAJCSAgIjogUmVnaXN0ZXJlZCBmb3IgSU9DIHJlc2V0IG5vdGlmaWNhdGlvbnNc
biIpKTsKIAl9Cg==

------_=_NextPart_001_01C663F6.4812D2E5--
