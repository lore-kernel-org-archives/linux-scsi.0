From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: 2.6.9-rc1-mm5 qlogic oops
Date: Mon, 13 Sep 2004 16:06:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD04A1@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C499E6.5C9DDC56"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:427 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S269049AbUIMXLO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 19:11:14 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C499E6.5C9DDC56
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

> On Mon, 2004-09-13 at 14:24, Andrew Vasquez wrote:
> > On Mon, 13 Sep 2004, Badari Pulavarty wrote:
> >=20
> > >=20
> > > I get this Oops with qlogic 2200 FC controllers with
> > > 2.6.9-rc1-mm5. Is this a known issue ? Any fixes ?
> > >=20
> >=20
> > Hmm, there seems to be some merging problems in changeset 1.44 for
> > qla_os.c -- the 'DMA pool/api usage' patch I sent is not completely
> > integrated (appears to be massaging problems while attempting to
> > apply on top off 1.43).=20
> >=20
> > Please apply the attached patch which should address the issue.
> >=20

On Monday, September 13, 2004 3:48 PM, Badari Pulavarty wrote:
> It worked.
>

James,

Please apply the attached patch (I missed you in the CC list for my=20
original reply).  The driver in its current state will panic during=20
load.

Regards,
Andrew Vasquez

------_=_NextPart_001_01C499E6.5C9DDC56
Content-Type: application/octet-stream;
	name="dma_fixups.diff"
Content-Transfer-Encoding: base64
Content-Description: dma_fixups.diff
Content-Disposition: attachment;
	filename="dma_fixups.diff"

PT09PT0gZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMgMS40NiB2cyBlZGl0ZWQgPT09PT0K
LS0tIDEuNDYvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMJMjAwNC0wOS0wNiAxMjowNzo1
MiAtMDc6MDAKKysrIGVkaXRlZC9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYwkyMDA0LTA5
LTEzIDE0OjA3OjIzIC0wNzowMApAQCAtMjg5Miw2ICsyODkyLDE5IEBACiAJCQljb250aW51ZTsK
IAkJfQogCisJCS8qIGdldCBjb25zaXN0ZW50IG1lbW9yeSBhbGxvY2F0ZWQgZm9yIGluaXQgY29u
dHJvbCBibG9jayAqLworCQloYS0+aW5pdF9jYiA9IGRtYV9wb29sX2FsbG9jKGhhLT5zX2RtYV9w
b29sLCBHRlBfS0VSTkVMLAorCQkgICAgJmhhLT5pbml0X2NiX2RtYSk7CisJCWlmIChoYS0+aW5p
dF9jYiA9PSBOVUxMKSB7CisJCQlxbGFfcHJpbnRrKEtFUk5fV0FSTklORywgaGEsCisJCQkgICAg
Ik1lbW9yeSBBbGxvY2F0aW9uIGZhaWxlZCAtIGluaXRfY2JcbiIpOworCisJCQlxbGEyeDAwX21l
bV9mcmVlKGhhKTsKKwkJCW1zbGVlcCgxMDApOworCisJCQljb250aW51ZTsKKwkJfQorCQltZW1z
ZXQoaGEtPmluaXRfY2IsIDAsIHNpemVvZihpbml0X2NiX3QpKTsKIAogCQkvKiBHZXQgY29uc2lz
dGVudCBtZW1vcnkgYWxsb2NhdGVkIGZvciBHZXQgUG9ydCBEYXRhYmFzZSBjbWQgKi8KIAkJaGEt
PmlvZGVzY19wZCA9IGRtYV9wb29sX2FsbG9jKGhhLT5zX2RtYV9wb29sLCBHRlBfS0VSTkVMLApA
QCAtMjk4MiwyMSArMjk5NSw2IEBACiAJCQl9CiAJCQltZW1zZXQoaGEtPmN0X3NucywgMCwgc2l6
ZW9mKHN0cnVjdCBjdF9zbnNfcGt0KSk7CiAJCX0KLQotCQkvKiBHZXQgY29uc2lzdGVudCBtZW1v
cnkgYWxsb2NhdGVkIGZvciBHZXQgUG9ydCBEYXRhYmFzZSBjbWQgKi8KLQkJaGEtPmlvZGVzY19w
ZCA9IHBjaV9hbGxvY19jb25zaXN0ZW50KGhhLT5wZGV2LAotCQkgICAgUE9SVF9EQVRBQkFTRV9T
SVpFLCAmaGEtPmlvZGVzY19wZF9kbWEpOwotCQlpZiAoaGEtPmlvZGVzY19wZCA9PSBOVUxMKSB7
Ci0JCQkvKiBlcnJvciAqLwotCQkJcWxhX3ByaW50ayhLRVJOX1dBUk5JTkcsIGhhLAotCQkJICAg
ICJNZW1vcnkgQWxsb2NhdGlvbiBmYWlsZWQgLSBpb2Rlc2NfcGRcbiIpOwotCi0JCQlxbGEyeDAw
X21lbV9mcmVlKGhhKTsKLQkJCW1zbGVlcCgxMDApOwotCi0JCQljb250aW51ZTsKLQkJfQotCQlt
ZW1zZXQoaGEtPmlvZGVzY19wZCwgMCwgUE9SVF9EQVRBQkFTRV9TSVpFKTsKIAogCQkvKiBEb25l
IGFsbCBhbGxvY2F0aW9ucyB3aXRob3V0IGFueSBlcnJvci4gKi8KIAkJc3RhdHVzID0gMDsK

------_=_NextPart_001_01C499E6.5C9DDC56--
