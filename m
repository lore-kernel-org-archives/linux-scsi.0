From: Matthew Thode <prometheanfire@gentoo.org>
Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
Date: Thu, 13 Feb 2014 23:48:17 -0600
Message-ID: <52FDAE21.7070309@gentoo.org>
References: <52EC60C3.1080103@gentoo.org>	<20140203092409.63ffd9a0@jlaw-desktop.mno.stratus.com>	<188de80a52694613b5a1a045d0658256@CO1PR07MB298.namprd07.prod.outlook.com>	<20140212114308.4f57a8b5@jlaw-desktop.mno.stratus.com>	<52FBB257.10304@gentoo.org> <CAA9_cmfVuCsRnDvjs5YWWn7-WbDVvyu=M2DNCaE8jsPH51906w@mail.gmail.com> <52FBCE6E.50703@gentoo.org>
Reply-To: prometheanfire@gentoo.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pu3elTVvtLFsouBnlUUixfBOTSUd56GCL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:34900 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbaBNFsc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 00:48:32 -0500
In-Reply-To: <52FBCE6E.50703@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Yao <ryao@gentoo.org>, Dan Williams <dan.j.williams@intel.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "kernel@gentoo.org" <kernel@gentoo.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pu3elTVvtLFsouBnlUUixfBOTSUd56GCL
Content-Type: multipart/mixed;
 boundary="------------050000080109040203050300"

This is a multi-part message in MIME format.
--------------050000080109040203050300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/12/2014 01:41 PM, Richard Yao wrote:
> On 02/12/2014 02:25 PM, Dan Williams wrote:
>> On Wed, Feb 12, 2014 at 9:41 AM, Richard Yao <ryao@gentoo.org> wrote:
>>> You should use `git send-email` to send the patch to all of the peopl=
e
>>> listed by get_maintainer.pl:
>>
>> I see nothing wrong with the patch Joe originally submitted:
>> http://marc.info/?l=3Dlinux-scsi&m=3D138609455422179&w=3D2
>>
>>>
>>> richard@desktop ~/devel/linux $ scripts/get_maintainer.pl --file
>>> drivers/scsi/scsi_transport_sas.c
>>> "James E.J. Bottomley" <JBottomley@parallels.com> (maintainer:SCSI
>>> SUBSYSTEM)
>>> linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
>>> linux-kernel@vger.kernel.org (open list)
>>>
>>> If I see that James E.J. Bottomley is already on CC for this discussi=
on,
>>> but my recent (and first) experience submitting a patch for another
>>> subsystem was that they are ignored unless this strict procedure is
>>> followed.
>>>
>>> If the maintainer does not respond within a month after doing this, I=

>>> suggest informing Linus Torvalds via email that the subsystem maintai=
ner
>>> is non-responsive.
>>>
>>
>> Just re-ping James, he'll get to it...
>>
>=20
> That was intended as generic advice. Sadly, I don't have a copy of the
> email headers for the original patch submission, so I can't inspect it.=

>=20
> That being said, I am receiving these emails because I suggested Matthe=
w
> to include the Gentoo kernel team alias on the CC list when I advised
> him to send this report upstream.
>=20
Confirmed that it now works (I luksClosed the device, removed it from
the system, waited a few seconds, readded it and checked dmesg).

--=20
-- Matthew Thode (prometheanfire)

--------------050000080109040203050300
Content-Type: application/pgp-keys;
 name="0x40AC5AC3.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0x40AC5AC3.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.22 (GNU/Linux)

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
XWPW2DfAEjM2nw=3D=3D
=3DCiwU
-----END PGP PUBLIC KEY BLOCK-----

--------------050000080109040203050300--

--pu3elTVvtLFsouBnlUUixfBOTSUd56GCL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/a4uAAoJECRx6z5ArFrDYmcP/3amHv3arXsDddUOqJSlkrK7
7YYU36M/+pHwnFuPsfNXsPK0JZ/VzJzJNYNH0ezeXIZRqRNTytWXA9+fZemQpYy0
S3BrjKmnSs3bYvWGAg0XDOol8qM6q9vGMjtbrDFoLQjSxwpTb5QtgFcgxkqg4Iwm
ac1FOtiCnZgCxmc7mTqrMd3K7zcBaGsMdaE5Kldo0gV42wczdcBpcKCfhu8HMYOE
wCGZPwF+Xjey3oL9uzm3SsgmHD9UKgfYXh0nv6nWwoxfLUwc3CQpaXhmTzpdxb4W
kcWqlmLuRjIk2gp4Qq+grptL1RQM05rf5yAQ/NSn/tzXnCW2V2DrR2YGNH++79z4
k+AEh105sBwueL3LjdXI2adJ351kFi4hNUlqjtcvpQ5CHsiQUkga1ps3c3IG5Cz+
XMhNCYDoomEN2Rnbd8M2nviV/gP9D1gu9wWShHRKLOXHYu4diouFli2KfkCAs/yw
Ncm+bCU0bW3P1i6abwLV3B1paEfVOTwwVKGqO0E/SmdpNP4yO+PzIu0zDxMzgfCi
s/9CMn0SG7vi6lJT6iymbuzosdB5ZFNxeBiY8TDlvHhOGafddtZfjwobnnp+WKp6
Y1MfvKlMXS82TA5mrBDLLfiTqT8ulySH94o/gURv+yKtcyPfJUOXv2MeRNC5qZpe
aCb/VJvu1rpWSej4uAiV
=faL2
-----END PGP SIGNATURE-----

--pu3elTVvtLFsouBnlUUixfBOTSUd56GCL--
