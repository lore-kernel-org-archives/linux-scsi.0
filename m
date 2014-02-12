From: Richard Yao <ryao@gentoo.org>
Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
Date: Wed, 12 Feb 2014 12:41:43 -0500
Message-ID: <52FBB257.10304@gentoo.org>
References: <52EC60C3.1080103@gentoo.org>	<20140203092409.63ffd9a0@jlaw-desktop.mno.stratus.com>	<188de80a52694613b5a1a045d0658256@CO1PR07MB298.namprd07.prod.outlook.com> <20140212114308.4f57a8b5@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jCLPncqu4XxmfgTJO0TPbu8ISS86R7cbr"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:42136 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbaBLRlz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 12:41:55 -0500
In-Reply-To: <20140212114308.4f57a8b5@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Cc: "prometheanfire@gentoo.org" <prometheanfire@gentoo.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "kernel@gentoo.org" <kernel@gentoo.org>, Dan Williams <dan.j.williams@intel.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jCLPncqu4XxmfgTJO0TPbu8ISS86R7cbr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

You should use `git send-email` to send the patch to all of the people
listed by get_maintainer.pl:

richard@desktop ~/devel/linux $ scripts/get_maintainer.pl --file
drivers/scsi/scsi_transport_sas.c
"James E.J. Bottomley" <JBottomley@parallels.com> (maintainer:SCSI
SUBSYSTEM)
linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)

If I see that James E.J. Bottomley is already on CC for this discussion,
but my recent (and first) experience submitting a patch for another
subsystem was that they are ignored unless this strict procedure is
followed.

If the maintainer does not respond within a month after doing this, I
suggest informing Linus Torvalds via email that the subsystem maintainer
is non-responsive.

On 02/12/2014 11:43 AM, Joe Lawrence wrote:
> Hi Sreekanth,
>=20
> There hasn't been much recent activity in
> drivers/scsi/scsi_transport_sas.c, so I wasn't sure who could best
> review the patch.
>=20
> Dan Williams added sas_rphy_unlink() back in 2011, perhaps he can
> remember why sas_bsg_remove wasn't performed there?
>=20
> Regards,
>=20
> -- Joe
>=20
>=20
> On Wed, 12 Feb 2014 11:43:58 +0000
> "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com> wrote:
>=20
>> Hi Joe,
>>
>> May I known the status of this patch having subject
>> "[PATCH] scsi_transport_sas: move bsg destructor into sas_rphy_remove"=
=2E
>>
>> I need the status of this patch as I am also observing the same WARNIN=
G call trace on latest 3.14.0-rc2+ kernel whenever we unload the mpt2sas/=
mpt3sas driver or whenever we unplug the drive attached to the HBA.
>> But after applying yours patch, these WARNING call trace is not observ=
ed.
>>
>> Regards,
>> Sreekanth
>>
>>> -----Original Message-----
>>> From: Joe Lawrence [mailto:joe.lawrence@stratus.com]
>>> Sent: Monday, February 03, 2014 7:54 PM
>>> To: prometheanfire@gentoo.org
>>> Cc: Nandigama, Nagalakshmi; Reddy, Sreekanth; Support; DL-MPT Fusion
>>> Linux; linux-scsi@vger.kernel.org; JBottomley@parallels.com; linux-
>>> kernel@vger.kernel.org; kernel@gentoo.org
>>> Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13=
=2E1
>>>
>>> On Fri, 31 Jan 2014 20:49:39 -0600
>>> Matthew Thode <prometheanfire@gentoo.org> wrote:
>>>
>>>> I decided to pull a drive while it was in use out of laziness (it wa=
s
>>>> open via luks, but not in actual use).  Got a fun trace as a result.=

>>>> Just thought you'd like to know :D
>>>>
>>>
>>> Hi Matthew,
>>>
>>> The first trace looks a lot like what I see on mpt2sas driver removal=
 [1].  I
>>> posted a suggested fix back in Dec [2], which you might try, however =
it is not
>>> reviewed at this point.
>>>
>>> [1] http://thread.gmane.org/gmane.linux.scsi/86237
>>> [2] https://github.com/joe-
>>> lawrence/linux/compare/scsi_transport_sas_sysfs_warning.patch
>>>
>>> Regards,
>>>
>>> -- Joe
>>
>=20



--jCLPncqu4XxmfgTJO0TPbu8ISS86R7cbr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+7JeAAoJECDuEZm+6ExkorUQAJYreT8C4z9Wd2NJcZbNE+EY
HwaaeRSIa4gYTN/XurY2w4GhnZDoGOqmYinhaA0PUHyPWry/IbDQCTZsju8G5teC
ddMQfcF8S3EyHdPeVQker1XS8uexS0baVZ+qTYiUNFIL0BhBv+GGae/6jAEudvOE
ClZ/vYJ5v4AhUs4LegGQ8t++4MWeQ1+O3NsxC5wFvE+ike1dL+QYbjIfHbP2VxU0
ZVtX35rTRhbd8rUjKlyP1/Lm1nSG2/Bipcdujy1IRdFZGuB6Rx20k9UbMbXol1Y1
sIsk8z0HAah0F8KwevK0+Q32b3cAUjlCnvHEpF5dcr9E/PPc0RDdL42jw/iWV7wy
7U5RyPMeMEd7qppd569mqXQmgLWJ42SUz0vla2JiwI38HZL61Whc5CJ3cIbU1eXc
AYOJztmsEypafl7fAwUA3uPxYneTa3lLz8zOATmC9z57L1RXpryTD/DIMfYoJiWu
jwmHX1dwDQ5zo5CL0Rnwf7Lxt97uqkYbz7JUkI2ibRbn+ra8ITGiw25u68G5ogIx
QPOb+TjVkfXRex1nkr/YXRES1WP0eaP/SAaKLxzxDffrGpCOuh5U5QPz/T9NBYmg
DeSZfJX8Fgc0tCAw06KzVGkzVEezP5L9oSMeFF+EnCLMMpyOzjWa7bft6sQ/y+Jy
t1A9MIpV1MBSQ5RnVkJZ
=nGFz
-----END PGP SIGNATURE-----

--jCLPncqu4XxmfgTJO0TPbu8ISS86R7cbr--
