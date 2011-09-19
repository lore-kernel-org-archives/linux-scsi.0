From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: Re: [PATCH] [SCSI]: libsas failure to revalidate domain for anything but the first expander child.
Date: Mon, 19 Sep 2011 09:55:32 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018AE0ED@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CC76EC.F2AB3056"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:56634 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab1ISRF3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2011 13:05:29 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Luben Tuikov <ltuikov@yahoo.com>, Darrick J Wong <djwong@us.ibm.com>, James Bottomley <jbottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>, Jack Wang <jack_wang@usish.com>, Dan Williams <dan.j.williams@intel.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01CC76EC.F2AB3056
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Three weeks, and this simple and obvious patch has had two positive
reviews and no propagation. Who do I have to buy a Pint of Guinness for
to get this moving upstream? ;-}

Sincerely -- Mark Salyzyn

-----Original Message-----
From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
Behalf Of Dan Williams
Sent: Wednesday, September 07, 2011 3:26 PM
To: Mark Salyzyn
Cc: linux-scsi@vger.kernel.org; Luben Tuikov; Darrick J Wong; James
Bottomley; Xiangliang Yu; Jack Wang
Subject: Re: [PATCH] [SCSI]: libsas failure to revalidate domain for
anything but the first expander child.

. . .

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

. . .

Reviewed-by: Luben Tuikov <ltuikov@yahoo.com>
I don't mind this patch.

______________________________________________________________________
This email may contain privileged or confidential information, which shou=
ld only be used for the purpose for which it was sent by Xyratex. No furt=
her rights or licenses are granted to use such information. If you are no=
t the intended recipient of this message, please notify the sender by ret=
urn and delete it. You may not use, copy, disclose or rely on the informa=
tion contained in it.
 =

Internet email is susceptible to data corruption, interception and unauth=
orised amendment for which Xyratex does not accept liability. While we ha=
ve taken reasonable precautions to ensure that this email is free of viru=
ses, Xyratex does not accept liability for the presence of any computer v=
iruses in this email, nor for any losses caused as a result of viruses.
 =

Xyratex Technology Limited (03134912), Registered in England & Wales, Reg=
istered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 =

The Xyratex group of companies also includes, Xyratex Ltd, registered in =
Bermuda, Xyratex International Inc, registered in California, Xyratex (Ma=
laysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd =
registered in The People's Republic of China and Xyratex Japan Limited re=
gistered in Japan.
______________________________________________________________________
 =

=0D
------_=_NextPart_001_01CC76EC.F2AB3056
Content-Type: text/x-patch;
	name="expander_bug.patch"
Content-Transfer-Encoding: base64
Content-Description: expander_bug.patch
Content-Disposition: attachment;
	filename="expander_bug.patch"

RnJvbSBlMzU2OWNmNmU3MWY5NDM1YWY4NDc2YzY3Mjk2MjRjZjMyODcwMzI2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJrIFNhbHl6eW4gPG1hcmtfc2FseXp5bkB1cy54eXJhdGV4
LmNvbT4KRGF0ZTogVGh1LCAxIFNlcCAyMDExIDA2OjExOjE3IC0wNzAwClN1YmplY3Q6IFtQQVRD
SF0gbGlic2FzOiBmYWlsdXJlIHRvIHJldmFsaWRhdGUgZG9tYWluIGZvciBhbnl0aGluZyBidXQg
dGhlCiBmaXJzdCBleHBhbmRlciBjaGlsZAoKSW4gYW4gZW5jbG9zdXJlIG1vZGVsIHdoZXJlIHRo
ZXJlIGFyZSBjaGFpbmluZyBleHBhbmRlcnMgdG8gYSBsYXJnZSBib2R5Cm9mIHN0b3JhZ2UsIGl0
IHdhcyBkaXNjb3ZlcmVkIHRoYXQgbGlic2FzLCByZXNwb25kaW5nIHRvIGEgYnJvYWRjYXN0CmV2
ZW50IGNoYW5nZSwgd291bGQgb25seSByZXZhbGlkYXRlIHRoZSBkb21haW4gb2YgZmlyc3QgY2hp
bGQgZXhwYW5kZXIKaW4gdGhlIGxpc3QuCgpUaGUgaXNzdWUgaXMgdGhhdCB0aGUgcG9pbnRlciB2
YWx1ZSB0byB0aGUgZGlzY292ZXJlZCBzb3VyY2UgZGV2aWNlIHdhcwp1c2VkIHRvIGJyZWFrIG91
dCBvZiB0aGUgbG9vcCwgcmF0aGVyIHRoYW4gdGhlIGNvbnRlbnQgb2YgdGhlIHBvaW50ZXIuCgpU
aGlzIHN0aWxsIHJlbWFpbnMgbm9uLWNvbXBsaWFudCBhcyB0aGUgcmV2YWxpZGF0ZSBkb21haW4g
Y29kZSBpcwpzdXBwb3NlZCB0byBsb29wIHRocm91Z2ggYWxsIGNoaWxkIGV4cGFuZGVycywgYW5k
IG5vdCBzdG9wIGF0IHRoZSBmaXJzdApvbmUgaXQgZmluZHMgdGhhdCByZXBvcnRzIGEgY2hhbmdl
IGNvdW50LiBIb3dldmVyLCB0aGUgZGVzaWduIG9mIHRoaXMKcm91dGluZSBkb2VzIG5vdCBhbGxv
dyBtdWx0aXBsZSBkZXZpY2UgZGlzY292ZXJpZXMgYW5kIHRoYXQgd291bGQgYmUgYQptb3JlIGNv
bXBsaWNhdGVkIHNldCBvZiBwYXRjaGVzIHJlc2VydmVkIGZvciBhbm90aGVyIGRheS4gV2UgYXJl
IGZpeGluZwp0aGUgZ2xhcmluZyBidWcgcmF0aGVyIHRoYW4gcmVmYWN0b3JpbmcgdGhlIGNvZGUu
CgpDYzogTHViZW4gVHVpa292IDx0dWlrb3ZAeWFob28uY29tPgpDYzogRGFycmljayBKIFdvbmcg
PGRqd29uZ0B1cy5pYm0uY29tPgpDYzogSmFtZXMgQm90dG9tbGV5IDxqYm90dG9tbGV5QHBhcmFs
bGVscy5jb20+ClJldmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVs
LmNvbT4KU2lnbmVkLW9mZi1ieTogTWFyayBTYWx5enluIDxtc2FseXp5bkB1cy54eXJhdGV4LmNv
bT4KLS0tCiBkcml2ZXJzL3Njc2kvbGlic2FzL3Nhc19leHBhbmRlci5jIHwgICAgMiArLQogMSBm
aWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYyBiL2RyaXZlcnMvc2NzaS9saWJz
YXMvc2FzX2V4cGFuZGVyLmMKaW5kZXggODc0ZTI5ZC4uN2Q2ODUxNyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zY3NpL2xpYnNhcy9zYXNfZXhwYW5kZXIuYworKysgYi9kcml2ZXJzL3Njc2kvbGlic2Fz
L3Nhc19leHBhbmRlci5jCkBAIC0xNzE4LDcgKzE3MTgsNyBAQCBzdGF0aWMgaW50IHNhc19maW5k
X2JjYXN0X2RldihzdHJ1Y3QgZG9tYWluX2RldmljZSAqZGV2LAogCWxpc3RfZm9yX2VhY2hfZW50
cnkoY2gsICZleC0+Y2hpbGRyZW4sIHNpYmxpbmdzKSB7CiAJCWlmIChjaC0+ZGV2X3R5cGUgPT0g
RURHRV9ERVYgfHwgY2gtPmRldl90eXBlID09IEZBTk9VVF9ERVYpIHsKIAkJCXJlcyA9IHNhc19m
aW5kX2JjYXN0X2RldihjaCwgc3JjX2Rldik7Ci0JCQlpZiAoc3JjX2RldikKKwkJCWlmICgqc3Jj
X2RldikKIAkJCQlyZXR1cm4gcmVzOwogCQl9CiAJfQotLSAKMS43LjYKCg==

------_=_NextPart_001_01CC76EC.F2AB3056--
