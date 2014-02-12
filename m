From: Matthew Thode <prometheanfire@gentoo.org>
Subject: Re: mpt2sas driver barfs when force removing a drive on 3.13.1
Date: Wed, 12 Feb 2014 13:46:32 -0600
Message-ID: <52FBCF98.3030304@gentoo.org>
References: <52EC60C3.1080103@gentoo.org>	<20140203092409.63ffd9a0@jlaw-desktop.mno.stratus.com>	<188de80a52694613b5a1a045d0658256@CO1PR07MB298.namprd07.prod.outlook.com>	<20140212114308.4f57a8b5@jlaw-desktop.mno.stratus.com>	<52FBB257.10304@gentoo.org> <CAA9_cmfVuCsRnDvjs5YWWn7-WbDVvyu=M2DNCaE8jsPH51906w@mail.gmail.com> <52FBCE6E.50703@gentoo.org>
Reply-To: prometheanfire@gentoo.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="kwnTIG3fLqm4LQIWhvbdEtMVkO8nbfUjm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:55336 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbaBLTqy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 14:46:54 -0500
In-Reply-To: <52FBCE6E.50703@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Yao <ryao@gentoo.org>, Dan Williams <dan.j.williams@intel.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, Support <support@lsi.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "kernel@gentoo.org" <kernel@gentoo.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kwnTIG3fLqm4LQIWhvbdEtMVkO8nbfUjm
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
I haven't had a chance to test this yet (I'm haven't rebooted yet).  I
do intend to let you know when I do reboot (probably tonight, the last
resliver is done 'soon').

--=20
-- Matthew Thode (prometheanfire)


--kwnTIG3fLqm4LQIWhvbdEtMVkO8nbfUjm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJS+8+6AAoJECRx6z5ArFrD54sQAJSsTnPSEzFeASldBuqWzI+i
GWN0KF1v7Y8fmpn5e3AtSk22mqb3jGIQPMM68rHXUOJcw5k4s1bz/ZYqTdjmqtlK
69FncMRVaB24/Vfxtjo4AFN2AxKyS2tZOSmtqipwfaieupQ+bE8mNJ1S8TwEDHk/
z6G8enr+2NTtARQJMMwKWQvto5VUTO3QbTLxJ/GcnatyZ00WVTJHpyklmBoD6hvb
oCrH/wvripZmfBex8SMhAZm+BFJ4W8XqPLmNj0rcdg559i1bi/Xi2WJ5jfSTK7PH
93Cx6i/kW3819SXoaj6Qf/Bj67+03IQ13Wm0VwzGvcDqA4YMKs5u2uc+oPXrkciH
w2rf8wiZ0sHXdeRKM2fu6jrA1Y67tAxiPaJCGb7LmxaSkTXNd/jHrzsLZ01XtjCw
SnzJ2RDRNclcxNMziQgLMhh+HAurXCKybBFJ0IQlQxJ2zVU16Qv1a9Y4uMtNY4YZ
5dEUzpAzBoc6YijmInkm4NDdjU4nnEEFUs4h8dyELpKmmYBknPkhczCFGAv3Vd0P
Gf0qfYULiRRsxLmdij1onTUBzcVjMZlsEqU4v1aTmFrPQ0GSJR3Empd2IvBQ+yDY
QZBosCeqdPj3SAn6bpbdSQAlrqcD4gQqzeQKLfqMykDfkCgF69XBxBDJb06TOGLM
k93zal4FFiN1JA0ShznA
=jOTd
-----END PGP SIGNATURE-----

--kwnTIG3fLqm4LQIWhvbdEtMVkO8nbfUjm--
