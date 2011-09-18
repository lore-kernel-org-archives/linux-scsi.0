From: Ben Hutchings <ben@decadent.org.uk>
Subject: RE: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Mon, 19 Sep 2011 00:00:18 +0100
Message-ID: <1316386825.14749.207.camel@deadeye>
References: <BAY151-W32DCB4BAFEC97DD4913A12A1090@phx.gbl>
	 <Pine.LNX.4.44L0.1109171330360.18455-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vFp15Xf86SzMcU+5MWKG"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1109171330360.18455-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Rocko Requin <rockorequin@hotmail.com>, tytso@mit.edu, Kernel development list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-vFp15Xf86SzMcU+5MWKG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-09-17 at 13:34 -0400, Alan Stern wrote:
> On Sat, 17 Sep 2011, Rocko Requin wrote:
>=20
> > > Why were you using gnome-terminal?  You should be running the tests a=
t
> > > a console VT, not under X at all.  Ctrl-Alt-F2 or the equivalent...
> >=20
> > Because with Ted's patch it doesn't crash when run from a console VT, e=
ven with an X server running.
>=20
> That's weird.  Maybe the screen updates change some timing.
>=20
> > > Here's another patch to address the new problem.  You can apply it on=
=20
> > > top of all the other patches.
> >=20
> > Attached is the crash log I get with the latest patch applied.
>=20
> Okay, more fallout from the same problem.  Here's an updated version of=
=20
> the previous patch.
[...]

There have been reports of this in Debian going back to 2.6.39:

http://bugs.debian.org/631187
http://bugs.debian.org/636263
http://bugs.debian.org/642043

Plus possibly related crashes in elv_put_request after CD-ROM removal:

http://bugs.debian.org/633890
http://bugs.debian.org/634681
http://bugs.debian.org/636103

The former was also reported in Ubuntu since their 2.6.38-10:

https://bugs.launchpad.net/debian/+source/linux-2.6/+bug/793796

The result of the discussion there was that it appeared to be a
regression due to commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b=20
("[SCSI] put stricter guards on queue dead checks") which was also
included in a stable update for 2.6.38.

There was also a report on bugzilla.kernel.org, though no-one can see
quite what that says now:

https://bugzilla.kernel.org/show_bug.cgi?id=3D38842

I also reported most of the above to James Bottomley and linux-scsi
nearly 2 months ago, to no response.

Ben.

--=20
Ben Hutchings
Power corrupts.  Absolute power is kind of neat.
                           - John Lehman, Secretary of the US Navy 1981-198=
7

--=-vFp15Xf86SzMcU+5MWKG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATnZ4Aue/yOyVhhEJAQr5/w/+JYOfDn1op+q6Tw4sqoU5jDpqCe9d9buX
iVcYpRqg1DgnqyFEX03f5e6SBH1Ml+bGn60kCNksaKSUa52R1U+E1zok7XXGraW5
EfdQilpJikq3Y1v1VgYrwNT49ar+KXT8jS7YMQzDrlHzgRdy4A7dMjlUdaEGBUkT
4OWj67yfDRN0rvKTFSt+25HqcDutob6MfUwR+nxyE6V/TqHE7s/d/g7BPG3JHe38
7S+EsUHY/r+Ad/TOefJWfOz72GEosQUWwwYGjQdakpIuygsmamwSXSjfzfJN2uci
Vni4TuwtHzQ9HsvW/xVRuBqdRt8W0FKKI4B5/xyS9S02u0eOv1lWNckuTVhHEXWw
JYHwcV5IHTen/J9UKwPZvhQDVmUuIoIpNBDyoclT98Mq2qBp05CmVV8wJ7n0j0Ia
6+XxP4WN0J/B1KKijzUcUMPonz9+VrP8j2+jYrvOfB4+bcyy6WWEzEktT4KiWNZV
Iaj/Olwy1ze9g/rHlSeiqXgB5wZ58Amlfnoj8rn/AjuBDWfDt6t7NqMUxdY2aTeH
U/MRMm9ISIZdCgxxGlDkCGd3X/55DeXvLWvjYOrgw1o3WqGeo5cYLOF9CTWeRm5X
yTghmeVWTJCwHCmz+D+ozFMFoUW5xjVx/xrJrL6zN8ZafrnBdB8/2zgH53UW2xGQ
x6H1fDnt3F4=
=CmPV
-----END PGP SIGNATURE-----

--=-vFp15Xf86SzMcU+5MWKG--
