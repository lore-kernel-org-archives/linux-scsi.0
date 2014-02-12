From: Richard Yao <ryao@gentoo.org>
Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
Date: Wed, 12 Feb 2014 14:41:34 -0500
Message-ID: <52FBCE6E.50703@gentoo.org>
References: <52EC60C3.1080103@gentoo.org>	<20140203092409.63ffd9a0@jlaw-desktop.mno.stratus.com>	<188de80a52694613b5a1a045d0658256@CO1PR07MB298.namprd07.prod.outlook.com>	<20140212114308.4f57a8b5@jlaw-desktop.mno.stratus.com>	<52FBB257.10304@gentoo.org> <CAA9_cmfVuCsRnDvjs5YWWn7-WbDVvyu=M2DNCaE8jsPH51906w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PHkQlmIkvgv8cfpx02iOcWdG3bLSkwidv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48667 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbaBLTlm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 14:41:42 -0500
In-Reply-To: <CAA9_cmfVuCsRnDvjs5YWWn7-WbDVvyu=M2DNCaE8jsPH51906w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, "prometheanfire@gentoo.org" <prometheanfire@gentoo.org>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "kernel@gentoo.org" <kernel@gentoo.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PHkQlmIkvgv8cfpx02iOcWdG3bLSkwidv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/12/2014 02:25 PM, Dan Williams wrote:
> On Wed, Feb 12, 2014 at 9:41 AM, Richard Yao <ryao@gentoo.org> wrote:
>> You should use `git send-email` to send the patch to all of the people=

>> listed by get_maintainer.pl:
>=20
> I see nothing wrong with the patch Joe originally submitted:
> http://marc.info/?l=3Dlinux-scsi&m=3D138609455422179&w=3D2
>=20
>>
>> richard@desktop ~/devel/linux $ scripts/get_maintainer.pl --file
>> drivers/scsi/scsi_transport_sas.c
>> "James E.J. Bottomley" <JBottomley@parallels.com> (maintainer:SCSI
>> SUBSYSTEM)
>> linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
>> linux-kernel@vger.kernel.org (open list)
>>
>> If I see that James E.J. Bottomley is already on CC for this discussio=
n,
>> but my recent (and first) experience submitting a patch for another
>> subsystem was that they are ignored unless this strict procedure is
>> followed.
>>
>> If the maintainer does not respond within a month after doing this, I
>> suggest informing Linus Torvalds via email that the subsystem maintain=
er
>> is non-responsive.
>>
>=20
> Just re-ping James, he'll get to it...
>=20

That was intended as generic advice. Sadly, I don't have a copy of the
email headers for the original patch submission, so I can't inspect it.

That being said, I am receiving these emails because I suggested Matthew
to include the Gentoo kernel team alias on the CC list when I advised
him to send this report upstream.


--PHkQlmIkvgv8cfpx02iOcWdG3bLSkwidv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+85yAAoJECDuEZm+6ExkAywQAI4/4l9Qs2PGcpjOA9Ltb7zu
HfUuhZSFN+/GJb84szjPi8qs7/9Q25tBarNtbC7D2ysIItGtaDI7R0mjumjxfiQs
uIMXSJ8c0ClmF5Kq68iXJJkN7KJ8h+SE1sPfmUcrqt+oz4xpAgCBQI2znYqbixnp
CxRkWe8UrPRhBRqNEgi+BItOgTV4EEPYgrZQDV1fdPeGfSugxatPivvC8yA+EUI4
+TVITuZQ3i10QF0/9kmC2Z23TVivHD76UBMBy5IdoEka1MNKklGGyNvj2E2tGEYW
cvnVoLBOfqOzqNn1h3uvLDMja6t8v+OqElhD1IYtS1PpPm6oFZoPyITFobGonJ7B
y2Gg/g+2lGIGa56TnNihynpsULO10pvUia/3LLcGKxvpVYztyVee67zRzTxVr/Op
r/cUeJuW8Xp74eY7yMFPduRGgRAszga5iQvte1cgnbWhKU3agS6y575w64gjwIWd
EDprXFqx5zZKJxlmdMtlZvLXqkLHGR4jQeGVfRc15HdefBZcqJOz5bXpohZPzFzj
RN12olLCrXdwLmOYrZYvJ69BuywH6FpgiuayawhDeJNHpXjokJrHAMzXIK5l4vvi
9q176urVq+8SZI1Skx1UydGMQMat+Wz2pd4jXv/ZXXQLPRi5hCvD71omv3yXozhv
/dqqBdjbM2rljldjer+R
=rG4+
-----END PGP SIGNATURE-----

--PHkQlmIkvgv8cfpx02iOcWdG3bLSkwidv--
