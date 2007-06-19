From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: add sysfs support for driver_version
Date: Tue, 19 Jun 2007 15:49:47 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22E32@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF0189EB31@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7B2AA.FDCA7AFC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:34423 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbXFSTtt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 15:49:49 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 5B8F618AEC3
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jun 2007 12:49:48 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF0189EB31@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7B2AA.FDCA7AFC
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Adding sysfs support for driver_version.

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

------_=_NextPart_001_01C7B2AA.FDCA7AFC
Content-Type: application/octet-stream;
	name="aacraid_sysfs_lld_version.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_sysfs_lld_version.patch
Content-Disposition: attachment;
	filename="aacraid_sysfs_lld_version.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDctMDYt
MTkgMTU6NDE6MTMuMjc4NDAwOTAzIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwNy0wNi0xOSAxNTo0NTowNS44OTAxNzI3NzUgLTA0MDAKQEAgLTc3MCw2ICs3NzAs
MTIgQEAKIAlyZXR1cm4gbGVuOwogfQogCitzdGF0aWMgc3NpemVfdCBhYWNfc2hvd19kcml2ZXJf
dmVyc2lvbihzdHJ1Y3QgY2xhc3NfZGV2aWNlICpjbGFzc19kZXYsCisJCWNoYXIgKmJ1ZikKK3sK
KwlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsICIlc1xuIiwgYWFjX2RyaXZlcl92ZXJz
aW9uKTsKK30KKwogc3NpemVfdCBhYWNfc2hvd19zZXJpYWxfbnVtYmVyKHN0cnVjdCBjbGFzc19k
ZXZpY2UgKmNsYXNzX2RldiwgY2hhciAqYnVmKQogewogCXN0cnVjdCBhYWNfZGV2ICpkZXYgPSAo
c3RydWN0IGFhY19kZXYqKWNsYXNzX3RvX3Nob3N0KGNsYXNzX2RldiktPmhvc3RkYXRhOwpAQCAt
ODYxLDYgKzg2NywxMyBAQAogCX0sCiAJLnNob3cgPSBhYWNfc2hvd19iaW9zX3ZlcnNpb24sCiB9
Oworc3RhdGljIHN0cnVjdCBjbGFzc19kZXZpY2VfYXR0cmlidXRlIGFhY19sbGRfdmVyc2lvbiA9
IHsKKwkuYXR0ciA9IHsKKwkJLm5hbWUgPSAiZHJpdmVyX3ZlcnNpb24iLAorCQkubW9kZSA9IFNf
SVJVR08sCisJfSwKKwkuc2hvdyA9IGFhY19zaG93X2RyaXZlcl92ZXJzaW9uLAorfTsKIHN0YXRp
YyBzdHJ1Y3QgY2xhc3NfZGV2aWNlX2F0dHJpYnV0ZSBhYWNfc2VyaWFsX251bWJlciA9IHsKIAku
YXR0ciA9IHsKIAkJLm5hbWUgPSAic2VyaWFsX251bWJlciIsCkBAIC04OTcsNiArOTEwLDcgQEAK
IAkmYWFjX2tlcm5lbF92ZXJzaW9uLAogCSZhYWNfbW9uaXRvcl92ZXJzaW9uLAogCSZhYWNfYmlv
c192ZXJzaW9uLAorCSZhYWNfbGxkX3ZlcnNpb24sCiAJJmFhY19zZXJpYWxfbnVtYmVyLAogCSZh
YWNfbWF4X2NoYW5uZWwsCiAJJmFhY19tYXhfaWQsCg==

------_=_NextPart_001_01C7B2AA.FDCA7AFC--
