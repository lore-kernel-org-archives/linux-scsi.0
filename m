From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [RFC][PATCH linux-firmware] isci: Add firmware blob and sources
Date: Thu, 29 Dec 2011 18:04:50 +0100
Message-ID: <1325178290.13595.44.camel@deadeye>
References: <1324142068.2825.341.camel@deadeye>
	 <CAA9_cmd9KMS3UBsQJ0WxT0rtQJVWceVwxvyXtRD+PuzwjUHUGA@mail.gmail.com>
	 <1324243556.2844.22.camel@deadeye>
	 <CAA9_cmdSE7njUQgEZkA+WKP=0is3fRiaxCMvPxg7i=vgn1Auuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-s/1vmbEGpA6V8BIvy9dJ"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmdSE7njUQgEZkA+WKP=0is3fRiaxCMvPxg7i=vgn1Auuw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-scsi@vger.kernel.org


--=-s/1vmbEGpA6V8BIvy9dJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-12-18 at 16:15 -0800, Dan Williams wrote:
> On Sun, Dec 18, 2011 at 1:25 PM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > On Sun, 2011-12-18 at 10:59 -0800, Dan Williams wrote:
> >> On Sat, Dec 17, 2011 at 9:14 AM, Ben Hutchings <ben@decadent.org.uk> w=
rote:
[...]
> >> > ---
> >> > I'm a bit unclear on the purpose and use of isci_firmware.bin.  Is i=
t
> >> > needed for production hardware?
> >>
> >> It's a stop gap for platforms with missing or broken oem parameters.
> >> It is meant to become vestigial once the platform revisions quiet
> >> down.
> >>
> >> > Does it need to be customised
> >> > per-system, or are module parameters sufficient for that?  (If not, =
why
> >> > isn't it built into the driver?)
> >>
> >> It is customized per system to meet EMI and signal integrity targets
> >> of a given platform.
> >
> > Given this, does it make sense to distribute a binary at all?
> >
>=20
> It defaults to something that is reasonable for a reference platform
> and if you end up needing to customize it is easier to distribute a
> new binary then move all these settings to module parameters.  That
> said, the intent was to start using WARN_TAINT_ONCE() if it ever got
> used and phase it out once the platform support stabilized.  It was
> certainly convenient to have it in the same tree in the early days of
> the driver.  Its use should be waning now.

I have now applied and pushed this addition to linux-firmware.git.

Ben.

--=20
Ben Hutchings
Design a system any fool can use, and only a fool will want to use it.

--=-s/1vmbEGpA6V8BIvy9dJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATvydsue/yOyVhhEJAQoTCw/+Pv1eLQg4Z2uUeR65kVLHOJNKe2ihPqBZ
CCjRmtiomYd8ARW1ELdxzaa9bCBxuiNTSrbu+HodWV/WqF2eD1X9MUoqf+5e4Voy
0vk5tXfiZHZeA3TwSmaXiYRHx3H4Ym0osvParwaOMBcS97iYeaFR26InXRMaIo46
bPV6dXc8x0Fv7wJ7pFXFdPt+2C5HmsdLOw5PpprhAFIfK4BI4Cc2VvnbzpzB54kH
Rzs11N6RKP+jTWo26J7XFIbOcWU7nN5DpgODE/2OfhQRNxB8LjF/IixL4/oFUocl
qgFc0ZxbpYMXyutfT/VRsbg+4A8jk7RfWBNP0zAgG6mn0jcJRGNAnoSby2RO8wiu
e82AxOAXn4EfREAxNx1NYuJzNv6WKRgxEp9dQYGsfZFeKv1GEzM2kqHhoPgbiB0Z
RT8sfIcA+Y4mwm7pbQOW7aowebTtqqbr+68JHzcxlje0CW46OcvdW8D1jvKKOngL
Hd/Kk1H5X1+sQ0auZEBZUJWGOY2dpDOTPLGmJ5TQtXQhfMxVBPgKTqeQqhELKNe3
NNJ30PxMM+oJQthh02iBr6QIh7+5FilzPsM0rLv86U3usrCnMEkngwm8wazJCui6
edQlQRFQsQjsLbqsJDYU0OBSReJv+go10QKbbZmN1FanIJ91ze6bAsh3v08pfqCF
uEr0sbLnHtY=
=26Js
-----END PGP SIGNATURE-----

--=-s/1vmbEGpA6V8BIvy9dJ--
