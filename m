From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 4/9] scsi: megaraid_sas - Driver provide the version to FW
Date: Fri, 19 Nov 2010 10:08:44 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4B6A08C587958942AA3002690DD4F8C30106A961F2cosmail02lsic_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:55917 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754965Ab0KSRJZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2010 12:09:25 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>, Tomas Henzl <thenzl@redhat.com>, "Karlikova, Lenka" <Lenka.Karlikova@lsi.com>, "Nielson, Mike" <Mike.Nielson@lsi.com>, "Jablonski, Charles" <Charles.Jablonski@lsi.com>

--_002_4B6A08C587958942AA3002690DD4F8C30106A961F2cosmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Driver added the version parmeter to provide the version to megaraid sas FW=
 during the driver load

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   22 ++++++++++++++++++++++
drivers/scsi/megaraid/megaraid_sas.h |    8 +++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

--_002_4B6A08C587958942AA3002690DD4F8C30106A961F2cosmail02lsic_
Content-Type: application/octet-stream; name="megasas-p4-version.patch"
Content-Description: megasas-p4-version.patch
Content-Disposition: attachment; filename="megasas-p4-version.patch";
	size=2466; creation-date="Thu, 18 Nov 2010 20:37:02 GMT";
	modification-date="Wed, 17 Nov 2010 13:09:11 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVwTiBvbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5jIG5ldy9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMKLS0tIG9sZC9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0xNCAxNTo0MDo1My4wMDAwMDAwMDAgLTA1
MDAKKysrIG5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0x
NCAxNTo0Nzo0Ny4wMDAwMDAwMDAgLTA1MDAKQEAgLTMxNDYsNiArMzE0NiwxNSBAQCBtZWdhc2Fz
X2lzc3VlX2luaXRfbWZpKHN0cnVjdCBtZWdhc2FzX2luCiAKIAlpbml0X2ZyYW1lLT5jbWQgPSBN
RklfQ01EX0lOSVQ7CiAJaW5pdF9mcmFtZS0+Y21kX3N0YXR1cyA9IDB4RkY7CisKKwlpZiAoaW5z
dGFuY2UtPnZlcmJ1ZikgeworCXNucHJpbnRmKChjaGFyICopaW5zdGFuY2UtPnZlcmJ1Ziwgc3Ry
bGVuKE1FR0FTQVNfVkVSU0lPTikgKyAyLCAiJXNcbiIsCisJCQlNRUdBU0FTX1ZFUlNJT04pOwor
CisJCWluaXRfZnJhbWUtPmRyaXZlcl92ZXJfbG8gPSBpbnN0YW5jZS0+dmVyYnVmX2g7CisJCWlu
aXRfZnJhbWUtPmRyaXZlcl92ZXJfaGkgPSAwOworCX0KKwogCWluaXRfZnJhbWUtPnF1ZXVlX2lu
Zm9fbmV3X3BoeXNfYWRkcl9sbyA9IGluaXRxX2luZm9faDsKIAogCWluaXRfZnJhbWUtPmRhdGFf
eGZlcl9sZW4gPSBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfaW5pdF9xdWV1ZV9pbmZvKTsKQEAgLTMz
MjMsNiArMzMzMiwxNCBAQCBzdGF0aWMgaW50IG1lZ2FzYXNfaW5pdF9tZmkoc3RydWN0IG1lZ2Fz
CiAJCWdvdG8gZmFpbF9yZXBseV9xdWV1ZTsKIAl9CiAKKwlpbnN0YW5jZS0+dmVyYnVmID0gcGNp
X2FsbG9jX2NvbnNpc3RlbnQoaW5zdGFuY2UtPnBkZXYsCisJCQkJCQlNRUdBU0FTX01BWF9OQU1F
KnNpemVvZih1MzIpLAorCQkJCQkJJmluc3RhbmNlLT52ZXJidWZfaCk7CisKKwlpZiAoIWluc3Rh
bmNlLT52ZXJidWYpIHsKKwkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IENhbid0IGFsbG9j
YXRlIHZlcnNpb24gYnVmZmVyXG4iKTsKKwl9CisKIAlpZiAobWVnYXNhc19pc3N1ZV9pbml0X21m
aShpbnN0YW5jZSkpCiAJCWdvdG8gZmFpbF9md19pbml0OwogCkBAIC00MjI4LDYgKzQyNDUsMTEg
QEAgc3RhdGljIHZvaWQgX19kZXZleGl0IG1lZ2FzYXNfZGV0YWNoX29uZQogCXBjaV9mcmVlX2Nv
bnNpc3RlbnQocGRldiwgc2l6ZW9mKHUzMiksIGluc3RhbmNlLT5jb25zdW1lciwKIAkJCSAgICBp
bnN0YW5jZS0+Y29uc3VtZXJfaCk7CiAKKwlpZiAoaW5zdGFuY2UtPnZlcmJ1ZikgeworCQlwY2lf
ZnJlZV9jb25zaXN0ZW50KHBkZXYsIE1FR0FTQVNfTUFYX05BTUUqc2l6ZW9mKHUzMiksCisJCQlp
bnN0YW5jZS0+dmVyYnVmLCBpbnN0YW5jZS0+dmVyYnVmX2gpOworCX0KKwogCXNjc2lfaG9zdF9w
dXQoaG9zdCk7CiAKIAlwY2lfc2V0X2RydmRhdGEocGRldiwgTlVMTCk7CmRpZmYgLXJ1cE4gb2xk
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaCBuZXcvZHJpdmVycy9zY3NpL21l
Z2FyYWlkL21lZ2FyYWlkX3Nhcy5oCi0tLSBvbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhcy5oCTIwMTAtMTEtMTEgMDU6NDY6MTkuMDAwMDAwMDAwIC0wNTAwCisrKyBuZXcvZHJp
dmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTAtMTEtMTQgMTQ6MjU6MTQuMDAw
MDAwMDAwIC0wNTAwCkBAIC03MDYsNiArNzA2LDcgQEAgc3RydWN0IG1lZ2FzYXNfY3RybF9pbmZv
IHsKICNkZWZpbmUgTUVHQVNBU19NQVhfTERfSURTCQkJKE1FR0FTQVNfTUFYX0xEX0NIQU5ORUxT
ICogXAogCQkJCQkJTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMKQogCisjZGVmaW5lIE1FR0FT
QVNfTUFYX05BTUUJCQkzMgogI2RlZmluZSBNRUdBU0FTX01BWF9TRUNUT1JTICAgICAgICAgICAg
ICAgICAgICAoMioxMDI0KQogI2RlZmluZSBNRUdBU0FTX0RCR19MVkwJCQkJMQogCkBAIC04ODcs
NyArODg4LDEwIEBAIHN0cnVjdCBtZWdhc2FzX2luaXRfZnJhbWUgewogCXUzMiBxdWV1ZV9pbmZv
X29sZF9waHlzX2FkZHJfbG87CS8qMjBoICovCiAJdTMyIHF1ZXVlX2luZm9fb2xkX3BoeXNfYWRk
cl9oaTsJLyoyNGggKi8KIAotCXUzMiByZXNlcnZlZF80WzZdOwkvKjI4aCAqLworCXUzMiBkcml2
ZXJfdmVyX2xvOworCXUzMiBkcml2ZXJfdmVyX2hpOworCisJdTMyIHJlc2VydmVkXzRbNF07CS8q
MjhoICovCiAKIH0gX19hdHRyaWJ1dGVfXyAoKHBhY2tlZCkpOwogCkBAIC0xMjU5LDYgKzEyNjMs
OCBAQCBzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSB7CiAJZG1hX2FkZHJfdCBwcm9kdWNlcl9oOwog
CXUzMiAqY29uc3VtZXI7CiAJZG1hX2FkZHJfdCBjb25zdW1lcl9oOworCXUzMiAqdmVyYnVmOwor
CWRtYV9hZGRyX3QgdmVyYnVmX2g7CiAKIAl1MzIgKnJlcGx5X3F1ZXVlOwogCWRtYV9hZGRyX3Qg
cmVwbHlfcXVldWVfaDsK

--_002_4B6A08C587958942AA3002690DD4F8C30106A961F2cosmail02lsic_--
