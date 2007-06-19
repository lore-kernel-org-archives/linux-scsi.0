From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: add support for long serial number information (take 2)
Date: Tue, 19 Jun 2007 16:29:24 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22E50@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22D67@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7B2B0.86B4C1DC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:35318 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbXFSU30 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 16:29:26 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 911401BEEF6
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jun 2007 13:29:25 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22D67@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7B2B0.86B4C1DC
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Compile error reported, missing definition of an automatic variable
(buffer). Thanks to those that watch over me :-)

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c  |   10 ++++++----
 drivers/scsi/aacraid/aacraid.h |    4 ++++
 drivers/scsi/aacraid/linit.c   |   12 +++++++++---
 3 files changed, 19 insertions(+), 7 deletions(-)

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
> Sent: Tuesday, June 19, 2007 11:53 AM
> To: linux-scsi@vger.kernel.org
> Subject: [PATCH] aacraid: add support for long serial number=20
> information
>=20
>=20
> Support displaying long serial number information. Reuse sysfs handler
> internally as helper.
>=20
> This attached patch is against current scsi-misc-2.6
>=20
> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
> handling of patch attachments.
>=20
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>=20
>  drivers/scsi/aacraid/aachba.c  |    9 +++++----
>  drivers/scsi/aacraid/aacraid.h |    4 ++++
>  drivers/scsi/aacraid/linit.c   |   12 +++++++++---
>  3 files changed, 18 insertions(+), 7 deletions(-)
>=20

------_=_NextPart_001_01C7B2B0.86B4C1DC
Content-Type: application/octet-stream;
	name="aacraid_serial_number2.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_serial_number2.patch
Content-Disposition: attachment;
	filename="aacraid_serial_number2.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDYtMTkgMTY6MTk6NDcuMjE5MDA1NDY0IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDYtMTkgMTY6MjI6NTEuNTQwMzUxOTg2IC0wNDAwCkBAIC0xMTc5LDYg
KzExNzksNyBAQAogCX0KIAogCWlmICghZGV2LT5pbl9yZXNldCkgeworCQljaGFyIGJ1ZmZlclsx
Nl07CiAJCXRtcCA9IGxlMzJfdG9fY3B1KGRldi0+YWRhcHRlcl9pbmZvLmtlcm5lbHJldik7CiAJ
CXByaW50ayhLRVJOX0lORk8gIiVzJWQ6IGtlcm5lbCAlZC4lZC0lZFslZF0gJS4qc1xuIiwKIAkJ
CWRldi0+bmFtZSwgCkBAIC0xMTk5LDEwICsxMjAwLDExIEBACiAJCQlkZXYtPm5hbWUsIGRldi0+
aWQsCiAJCQl0bXA+PjI0LCh0bXA+PjE2KSYweGZmLHRtcCYweGZmLAogCQkJbGUzMl90b19jcHUo
ZGV2LT5hZGFwdGVyX2luZm8uYmlvc2J1aWxkKSk7Ci0JCWlmIChsZTMyX3RvX2NwdShkZXYtPmFk
YXB0ZXJfaW5mby5zZXJpYWxbMF0pICE9IDB4QkFEMCkKLQkJCXByaW50ayhLRVJOX0lORk8gIiVz
JWQ6IHNlcmlhbCAleFxuIiwKLQkJCQlkZXYtPm5hbWUsIGRldi0+aWQsCi0JCQkJbGUzMl90b19j
cHUoZGV2LT5hZGFwdGVyX2luZm8uc2VyaWFsWzBdKSk7CisJCWJ1ZmZlclswXSA9ICdcMCc7CisJ
CWlmIChhYWNfc2hvd19zZXJpYWxfbnVtYmVyKAorCQkgIHNob3N0X3RvX2NsYXNzKGRldi0+c2Nz
aV9ob3N0X3B0ciksIGJ1ZmZlcikpCisJCQlwcmludGsoS0VSTl9JTkZPICIlcyVkOiBzZXJpYWwg
JXMiLAorCQkJICBkZXYtPm5hbWUsIGRldi0+aWQsIGJ1ZmZlcik7CiAJCWlmIChkZXYtPnN1cHBs
ZW1lbnRfYWRhcHRlcl9pbmZvLlZwZEluZm8uVHNpZFswXSkgewogCQkJcHJpbnRrKEtFUk5fSU5G
TyAiJXMlZDogVFNJRCAlLipzXG4iLAogCQkJICBkZXYtPm5hbWUsIGRldi0+aWQsCmRpZmYgLXJ1
IGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQv
YWFjcmFpZC5oCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY3JhaWQuaAkyMDA3LTA2LTE5
IDE2OjE5OjQ3LjIxOTAwNTQ2NCAtMDQwMAorKysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNy
YWlkLmgJMjAwNy0wNi0xOSAxNjoyMjo1MS41NDEzNTE4NjMgLTA0MDAKQEAgLTE4MjIsNiArMTgy
MiwxMCBAQAogaW50IGFhY19nZXRfY29udGFpbmVycyhzdHJ1Y3QgYWFjX2RldiAqZGV2KTsKIGlu
dCBhYWNfc2NzaV9jbWQoc3RydWN0IHNjc2lfY21uZCAqY21kKTsKIGludCBhYWNfZGV2X2lvY3Rs
KHN0cnVjdCBhYWNfZGV2ICpkZXYsIGludCBjbWQsIHZvaWQgX191c2VyICphcmcpOworI2lmbmRl
ZiBzaG9zdF90b19jbGFzcworI2RlZmluZSBzaG9zdF90b19jbGFzcyhzaG9zdCkgJnNob3N0LT5z
aG9zdF9jbGFzc2RldgorI2VuZGlmCitzc2l6ZV90IGFhY19zaG93X3NlcmlhbF9udW1iZXIoc3Ry
dWN0IGNsYXNzX2RldmljZSAqY2xhc3NfZGV2LCBjaGFyICpidWYpOwogaW50IGFhY19kb19pb2N0
bChzdHJ1Y3QgYWFjX2RldiAqIGRldiwgaW50IGNtZCwgdm9pZCBfX3VzZXIgKmFyZyk7CiBpbnQg
YWFjX3J4X2luaXQoc3RydWN0IGFhY19kZXYgKmRldik7CiBpbnQgYWFjX3JrdF9pbml0KHN0cnVj
dCBhYWNfZGV2ICpkZXYpOwpkaWZmIC1ydSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0LmMg
Yi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2xpbml0LmMJMjAwNy0wNi0xOSAxNjoxOTo0Ny4yMjAwMDUzNDEgLTA0MDAKKysrIGIvZHJpdmVy
cy9zY3NpL2FhY3JhaWQvbGluaXQuYwkyMDA3LTA2LTE5IDE2OjI0OjM2LjIzMDQ3MjU3NCAtMDQw
MApAQCAtNzcwLDE1ICs3NzAsMjEgQEAKIAlyZXR1cm4gbGVuOwogfQogCi1zdGF0aWMgc3NpemVf
dCBhYWNfc2hvd19zZXJpYWxfbnVtYmVyKHN0cnVjdCBjbGFzc19kZXZpY2UgKmNsYXNzX2RldiwK
LQkJY2hhciAqYnVmKQorc3NpemVfdCBhYWNfc2hvd19zZXJpYWxfbnVtYmVyKHN0cnVjdCBjbGFz
c19kZXZpY2UgKmNsYXNzX2RldiwgY2hhciAqYnVmKQogewogCXN0cnVjdCBhYWNfZGV2ICpkZXYg
PSAoc3RydWN0IGFhY19kZXYqKWNsYXNzX3RvX3Nob3N0KGNsYXNzX2RldiktPmhvc3RkYXRhOwog
CWludCBsZW4gPSAwOwogCiAJaWYgKGxlMzJfdG9fY3B1KGRldi0+YWRhcHRlcl9pbmZvLnNlcmlh
bFswXSkgIT0gMHhCQUQwKQotCQlsZW4gPSBzbnByaW50ZihidWYsIFBBR0VfU0laRSwgIiV4XG4i
LAorCQlsZW4gPSBzbnByaW50ZihidWYsIFBBR0VfU0laRSwgIiUwNlhcbiIsCiAJCSAgbGUzMl90
b19jcHUoZGV2LT5hZGFwdGVyX2luZm8uc2VyaWFsWzBdKSk7CisJaWYgKGxlbiAmJgorCSAgIW1l
bWNtcCgmZGV2LT5zdXBwbGVtZW50X2FkYXB0ZXJfaW5mby5NZmdQY2JhU2VyaWFsTm9bCisJICAg
IHNpemVvZihkZXYtPnN1cHBsZW1lbnRfYWRhcHRlcl9pbmZvLk1mZ1BjYmFTZXJpYWxObykrMi1s
ZW5dLAorCSAgYnVmLCBsZW4pKQorCQlsZW4gPSBzbnByaW50ZihidWYsIFBBR0VfU0laRSwgIiUu
KnNcbiIsCisJCSAgKGludClzaXplb2YoZGV2LT5zdXBwbGVtZW50X2FkYXB0ZXJfaW5mby5NZmdQ
Y2JhU2VyaWFsTm8pLAorCQkgIGRldi0+c3VwcGxlbWVudF9hZGFwdGVyX2luZm8uTWZnUGNiYVNl
cmlhbE5vKTsKIAlyZXR1cm4gbGVuOwogfQogCg==

------_=_NextPart_001_01C7B2B0.86B4C1DC--
