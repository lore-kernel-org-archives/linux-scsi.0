From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 1/9] scsi: megaraid_sas - Change the time format during the
 driver online controller reset
Date: Fri, 19 Nov 2010 09:33:47 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4B6A08C587958942AA3002690DD4F8C30106A961BDcosmail02lsic_"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

--_002_4B6A08C587958942AA3002690DD4F8C30106A961BDcosmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Change the 30 seconds wait in OCR routine to ssleep and give more time to F=
W come out from failed status

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)
=20

--_002_4B6A08C587958942AA3002690DD4F8C30106A961BDcosmail02lsic_
Content-Type: application/octet-stream; name="megasas-p1-timechange.patch"
Content-Description: megasas-p1-timechange.patch
Content-Disposition: attachment; filename="megasas-p1-timechange.patch";
	size=1292; creation-date="Thu, 18 Nov 2010 20:37:02 GMT";
	modification-date="Wed, 17 Nov 2010 13:09:11 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVwTiBvbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5jIG5ldy9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMKLS0tIG9sZC9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0xMCAwNDozOTo0OC4wMDAwMDAwMDAgLTA1
MDAKKysrIG5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0x
NCAxNTozMjozMS4wMDAwMDAwMDAgLTA1MDAKQEAgLTIyOTQsNyArMjI5NCw2IEBAIHByb2Nlc3Nf
Zndfc3RhdGVfY2hhbmdlX3dxKHN0cnVjdCB3b3JrX3MKIHsKIAlzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UgPQogCQljb250YWluZXJfb2Yod29yaywgc3RydWN0IG1lZ2FzYXNfaW5z
dGFuY2UsIHdvcmtfaW5pdCk7Ci0JdTMyIHdhaXQ7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKIAog
CWlmIChpbnN0YW5jZS0+YWRwcmVjb3ZlcnkgIT0gTUVHQVNBU19BRFBSRVNFVF9TTV9JTkZBVUxU
KSB7CkBAIC0yMzIwLDEwICsyMzE5LDggQEAgcHJvY2Vzc19md19zdGF0ZV9jaGFuZ2Vfd3Eoc3Ry
dWN0IHdvcmtfcwogCQlwcmludGsoS0VSTl9OT1RJQ0UgIm1lZ2FyYWlkX3NhczogSEJBIHJlY292
ZXJ5IHN0YXRlIG1hY2hpbmUsIgogCQkJCQkic3RhdGUgMiBzdGFydGluZy4uLlxuIik7CiAKLQkJ
Lyp3YWl0dGluZyBmb3IgYWJvdXQgMjAgc2Vjb25kIGJlZm9yZSBzdGFydCB0aGUgc2Vjb25kIGlu
aXQqLwotCQlmb3IgKHdhaXQgPSAwOyB3YWl0IDwgMzA7IHdhaXQrKykgewotCQkJbXNsZWVwKDEw
MDApOwotCQl9CisJCS8qd2FpdHRpbmcgZm9yIGFib3V0IDMwIHNlY29uZCBiZWZvcmUgc3RhcnQg
dGhlIHNlY29uZCBpbml0Ki8KKwkJc3NsZWVwKDMwKTsKIAogCQlpZiAobWVnYXNhc190cmFuc2l0
aW9uX3RvX3JlYWR5KGluc3RhbmNlKSkgewogCQkJcHJpbnRrKEtFUk5fTk9USUNFICJtZWdhcmFp
ZF9zYXM6YWRhcHRlciBub3QgcmVhZHlcbiIpOwpAQCAtMjQ4Nyw3ICsyNDg0LDkgQEAgbWVnYXNh
c190cmFuc2l0aW9uX3RvX3JlYWR5KHN0cnVjdCBtZWdhcwogCQljYXNlIE1GSV9TVEFURV9GQVVM
VDoKIAogCQkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZXIGluIEZBVUxUIHN0YXRlISFc
biIpOwotCQkJcmV0dXJuIC1FTk9ERVY7CisJCQltYXhfd2FpdCA9IE1FR0FTQVNfUkVTRVRfV0FJ
VF9USU1FOworCQkJY3VyX3N0YXRlID0gTUZJX1NUQVRFX0ZBVUxUOworCQkJYnJlYWs7CiAKIAkJ
Y2FzZSBNRklfU1RBVEVfV0FJVF9IQU5EU0hBS0U6CiAJCQkvKgo=

--_002_4B6A08C587958942AA3002690DD4F8C30106A961BDcosmail02lsic_--
