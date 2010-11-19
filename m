From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 2/9] scsi: megaraid_sas - Driver only report tape drive,
 JBOD and logic drives
Date: Fri, 19 Nov 2010 09:53:28 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4B6A08C587958942AA3002690DD4F8C30106A961D6cosmail02lsic_"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

--_002_4B6A08C587958942AA3002690DD4F8C30106A961D6cosmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Driver only report tape drive, JBOD and logic drives to OS

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--_002_4B6A08C587958942AA3002690DD4F8C30106A961D6cosmail02lsic_
Content-Type: application/octet-stream; name="megasas-p2-enclusure.patch"
Content-Description: megasas-p2-enclusure.patch
Content-Disposition: attachment; filename="megasas-p2-enclusure.patch";
	size=1255; creation-date="Thu, 18 Nov 2010 20:37:02 GMT";
	modification-date="Wed, 17 Nov 2010 13:09:11 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVwTiBvbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5jIG5ldy9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMKLS0tIG9sZC9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0xNCAxNTozMzoyNS4wMDAwMDAwMDAgLTA1
MDAKKysrIG5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0x
NCAxNTozNDowMC4wMDAwMDAwMDAgLTA1MDAKQEAgLTE0NDUsMTUgKzE0NDUsMjIgQEAgc3RhdGlj
IGludCBtZWdhc2FzX3NsYXZlX2NvbmZpZ3VyZShzdHJ1YwogCSogICAgICAgIFRoYXQgd2lsbCBi
ZSBmaXhlZCBvbmNlIExTSSBlbmdpbmVlcnMgaGF2ZSBhdWRpdGVkIHRoZQogCSogICAgICAgIGZp
cm13YXJlIGZvciBwb3NzaWJsZSBpc3N1ZXMuCiAJKi8KLQlpZiAoc2Rldi0+Y2hhbm5lbCA8IE1F
R0FTQVNfTUFYX1BEX0NIQU5ORUxTICYmCi0JCQkJc2Rldi0+dHlwZSA9PSBUWVBFX0RJU0spIHsK
LQkJcGRfaW5kZXggPSAoc2Rldi0+Y2hhbm5lbCAqIE1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5F
TCkgKwotCQkJCQkJCQlzZGV2LT5pZDsKLQkJaWYgKGluc3RhbmNlLT5wZF9saXN0W3BkX2luZGV4
XS5kcml2ZVN0YXRlID09Ci0JCQkJCQlNUl9QRF9TVEFURV9TWVNURU0pIHsKKwlpZiAoc2Rldi0+
Y2hhbm5lbCA8IE1FR0FTQVNfTUFYX1BEX0NIQU5ORUxTKSB7CisJCWlmIChzZGV2LT50eXBlID09
IFRZUEVfVEFQRSkgewogCQkJYmxrX3F1ZXVlX3JxX3RpbWVvdXQoc2Rldi0+cmVxdWVzdF9xdWV1
ZSwKIAkJCQlNRUdBU0FTX0RFRkFVTFRfQ01EX1RJTUVPVVQgKiBIWik7CiAJCQlyZXR1cm4gMDsK
KwkJfSBlbHNlIGlmIChzZGV2LT50eXBlID09IFRZUEVfRElTSykgeworCQlwZF9pbmRleCA9CisJ
CShzZGV2LT5jaGFubmVsICogTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMKSArIHNkZXYtPmlk
OworCQkJaWYgKChpbnN0YW5jZS0+cGRfbGlzdFtwZF9pbmRleF0uZHJpdmVTdGF0ZSA9PQorCQkJ
CQlNUl9QRF9TVEFURV9TWVNURU0pICYmCisJCQkJKGluc3RhbmNlLT5wZF9saXN0W3BkX2luZGV4
XS5kcml2ZVR5cGUgPT0KKwkJCQkJCVRZUEVfRElTSykpIHsKKwkJCQlibGtfcXVldWVfcnFfdGlt
ZW91dChzZGV2LT5yZXF1ZXN0X3F1ZXVlLAorCQkJCQlNRUdBU0FTX0RFRkFVTFRfQ01EX1RJTUVP
VVQgKiBIWik7CisJCQkJcmV0dXJuIDA7CisJCQl9CiAJCX0KIAkJcmV0dXJuIC1FTlhJTzsKIAl9
Cg==

--_002_4B6A08C587958942AA3002690DD4F8C30106A961D6cosmail02lsic_--
