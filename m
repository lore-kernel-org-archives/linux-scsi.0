From: <Yanqing_Liu@Dell.com>
Subject: RE: [Patch] scsi_dh_rdac.c: add Dell product information into rdacdevice handler
Date: Thu, 2 Oct 2008 12:18:33 -0500
Message-ID: <00FE57DD11E3A94893D5BD54C3358BE884BF3C@AUSX3MPC128.aus.amer.dell.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BF38@AUSX3MPC128.aus.amer.dell.com> <1222961465.3222.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C924B2.E5F9F1F2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:65403 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbYJBRSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 13:18:55 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1222961465.3222.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: sekharan@us.ibm.com, Shyam_Iyer@Dell.com, Matt_Domsch@Dell.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C924B2.E5F9F1F2
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Thanks James!

Attached is the patch.

Yanqing
---
=20

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]=20
Sent: Thursday, October 02, 2008 10:31 AM
To: Liu, Yanqing
Cc: dm-devel@redhat.com; linux-scsi@vger.kernel.org;
sekharan@us.ibm.com; Iyer, Shyam
Subject: Re: [Patch] scsi_dh_rdac.c: add Dell product information into
rdacdevice handler

On Thu, 2008-10-02 at 10:11 -0500, Yanqing_Liu@Dell.com wrote:
> Hi all,
>=20
> Re-send this patch in the proper format. Thanks for James's email=20
> about this.
> ---
>=20
> The following patch is to add Dell Powervault storage arrays into=20
> device list of rdac device handler.
>=20
>=20
> Signed-off-by: Yanqing Liu <yanqing_liu@dell.com>

This is all much better, thanks!

> --- linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
> 2008-09-29 02:31:26.000000000 -0400
> +++ linux-2.6.27-rc7/drivers/scsi/device_handler/scsi_dh_rdac.c
> 2008-09-30 02:06:26.000000000 -0400
> @@ -590,6 +590,8 @@
> {"STK", "OPENstorage D280"},
> {"SUN", "CSM200_R"},
> {"SUN", "LCSM100_F"},
> + {"DELL", "MD3000"},
> + {"DELL", "MD3000i"},
> {NULL, NULL},
> };

This, unfortunately, is still  unapplyable ... looks like exchange has
eaten the initial TABs.  No-one seems to have managed to get outlook to
behave properly as a patch submission tool, so if you can't use an
alternative email tool (see Documentation/email-clients.txt) then just
attach the patch (until someone works out how to get outlook to behave,
it's the one case where only mime email works).

James



------_=_NextPart_001_01C924B2.E5F9F1F2
Content-Type: application/octet-stream;
	name="rdacPatch"
Content-Transfer-Encoding: base64
Content-Description: rdacPatch
Content-Disposition: attachment;
	filename="rdacPatch"

VGhlIGZvbGxvd2luZyBwYXRjaCBpcyB0byBhZGQgRGVsbCBQb3dlcnZhdWx0IHN0b3JhZ2UgYXJy
YXlzIGludG8gZGV2aWNlIGxpc3QgZm9yIHJkYWMgZGV2aWNlIGhhbmRsZXIuCgpTaWduZWQtb2Zm
LWJ5OiBZYW5xaW5nIExpdSA8eWFucWluZ19saXVAZGVsbC5jb20+CgotLS0gbGludXgtMi42LjI3
LXJjNy9kcml2ZXJzL3Njc2kvZGV2aWNlX2hhbmRsZXIvc2NzaV9kaF9yZGFjLmMub3JpZwkyMDA4
LTA5LTI5IDAyOjMxOjI2LjAwMDAwMDAwMCAtMDQwMAorKysgbGludXgtMi42LjI3LXJjNy9kcml2
ZXJzL3Njc2kvZGV2aWNlX2hhbmRsZXIvc2NzaV9kaF9yZGFjLmMJMjAwOC0wOS0zMCAwMjowNjoy
Ni4wMDAwMDAwMDAgLTA0MDAKQEAgLTU5MCw2ICs1OTAsOCBAQAogCXsiU1RLIiwgIk9QRU5zdG9y
YWdlIEQyODAifSwKIAl7IlNVTiIsICJDU00yMDBfUiJ9LAogCXsiU1VOIiwgIkxDU00xMDBfRiJ9
LAorCXsiREVMTCIsICJNRDMwMDAifSwKKwl7IkRFTEwiLCAiTUQzMDAwaSJ9LAogCXtOVUxMLCBO
VUxMfSwKIH07CiAK

------_=_NextPart_001_01C924B2.E5F9F1F2--
