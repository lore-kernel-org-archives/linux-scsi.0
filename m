From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [RFC][PATCH linux-firmware] isci: Add firmware blob and sources
Date: Sun, 18 Dec 2011 21:25:56 +0000
Message-ID: <1324243556.2844.22.camel@deadeye>
References: <1324142068.2825.341.camel@deadeye>
	 <CAA9_cmd9KMS3UBsQJ0WxT0rtQJVWceVwxvyXtRD+PuzwjUHUGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-57pL3DIPV8/whev+/Blg"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53346 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088Ab1LRV0R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Dec 2011 16:26:17 -0500
In-Reply-To: <CAA9_cmd9KMS3UBsQJ0WxT0rtQJVWceVwxvyXtRD+PuzwjUHUGA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>


--=-57pL3DIPV8/whev+/Blg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-12-18 at 10:59 -0800, Dan Williams wrote:
> On Sat, Dec 17, 2011 at 9:14 AM, Ben Hutchings <ben@decadent.org.uk> wrot=
e:
> > isci requires a parameter blob which is usually found in NVRAM, but it
> > can fall back to loading with request_firmware().  These files are
> > taken from the Linux source tree where they were wrongly added in
> > Linux 3.0.
>=20
> Oh, I was of the impression that the external firmware tree was for
> license incompatible firmware images?

firmware/README.AddingFirmware doesn't say that the licence makes a
difference.

> > ---
> > I'm a bit unclear on the purpose and use of isci_firmware.bin.  Is it
> > needed for production hardware?
>=20
> It's a stop gap for platforms with missing or broken oem parameters.
> It is meant to become vestigial once the platform revisions quiet
> down.
>=20
> > Does it need to be customised
> > per-system, or are module parameters sufficient for that?  (If not, why
> > isn't it built into the driver?)
>=20
> It is customized per system to meet EMI and signal integrity targets
> of a given platform.

Given this, does it make sense to distribute a binary at all?

Ben.

> > probe_roms.h is labelled with a dual BSD/GPLv2 licence but the other
> > files had no licence header so I've treated them as GPLv2 by default.
>=20
> The latest version of probe_roms.h [1] supports the v1.3 oem parameter
> format, this patch appears to be v1.0 based.
>=20
> Regards,
> Dan
>=20
> [1]: http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/isci.git;a=3Dblob;f=
=3Ddrivers/scsi/isci/probe_roms.h;hb=3Drefs/heads/fixes

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-57pL3DIPV8/whev+/Blg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATu5aZOe/yOyVhhEJAQoYsg/+J2iHG3UKzsi09bvfvnHZ+1rioqDyVPPT
cJuKkcstXyJQ+urHg4dpaZebV67ZyG7aa0MKEuILhQcAPqJCIsFyLp5p/3urW8hq
+u5O1jMItxSRs0l7/zh+m3hf7P0fNWKXlq4KaEBxHJPtK0KmYZY3NmLDtJmVKuJt
h4bENcvclxHou8r/CUAxZABsH93nrhSo42Vck15Y671dIpDsYjKn+Kd/FxM1gJ/k
WRF1cckWS22yxJEGAjuqnlg5LRGHtFI9Su2IliVdObsoPv36UAXbvf7IJ75v989w
YGnlpOcNRS+NYki0Jsg20tCGaXFcHomNI9gFriKfuW9UYqo2OLraMKVWV0pAeu4F
1zArmKkwdugNGAKcxXZ5Ebwgk4jZjgQO7xreH8N4SLa9ooBoGPNSRCCX4YQWPD7b
0U4P5wux8Q4xl0iKnRVj3tLl0vWGna+svCkxuFU43UZFOdzbR+EQBrHc+nFR8UfZ
eC+LgKr0d20KMKAQx16GwPCkZSBd8S5qpianF/G9JhUs+TauNSvdpDKxVxg+VVuc
m5ZqUn+L3pHXJcbE2fK/doTlXeWQd5uI4Eh/oQ2c37aqOqojJXtAc+u7Gp6hMi6P
S8F5r/BxHgRhVoa4Q8N18V+TOcMGYnHRvGsfN3ihcZRPMYv5f8uumtMc71yr2Clm
fL/SzISsY6I=
=EF8N
-----END PGP SIGNATURE-----

--=-57pL3DIPV8/whev+/Blg--
