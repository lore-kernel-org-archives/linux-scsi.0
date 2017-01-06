From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [LSF/MM TOPIC] status update on stream IDs
Date: Fri, 6 Jan 2017 16:58:43 -0700
Message-ID: <7B0B6B53-D692-4084-AC63-55138132F509@dilger.ca>
References: <E86FC13D-0058-473C-B9D6-36B988ABEFFE@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_740B886B-92C7-4B32-8221-08D49D933AD6"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <E86FC13D-0058-473C-B9D6-36B988ABEFFE@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--Apple-Mail=_740B886B-92C7-4B32-8221-08D49D933AD6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

[resend to include other relevant lists]

On Jan 6, 2017, at 4:54 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>=20
> At LSF/MM'16 and Linux FAST (https://lwn.net/Articles/685499/) there =
were
> discussions about adding stream IDs to the block/device layer to allow =
higher
> layers (filesystems, applications) to identify IO streams so lower =
layers
> (SSDs, hybrid storage, etc.) can make better allocation/placement =
decisions.
>=20
> It would be useful to get an update on the state of this work, and =
discuss
> any obstacles that need to be resolved for getting this code landed.


Cheers, Andreas






--Apple-Mail=_740B886B-92C7-4B32-8221-08D49D933AD6
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWHAvM3Kl2rkXzB/gAQgqsBAArtsTzEdg40ycfKoGyOPpQ865W4Y9A0R8
7jI8Zyc22LLEsadZIVXWIeaQH3wzUqr7lzXg2dRgdUGvL1GYVB2UH4rktwRizo1k
pnOfm6vJTAGZfe8nPXg2vg8hagSGIfjn+we/Id/qx0EhjX2p4RE7grWlmInKX59B
WDnyUa7xeN2I8BNlKaZOIbtpvfAa2nPVCv6B4mJOvPkPPtXZFvXTaWUaKk2lXIIt
xtV45Ee4u8p7SOM6OP9Fagb9ONQgJ5Vnz0jiF8Slykork/T9ZUqV4A4pX1fd0gL/
CEEJPsRRuL9TO1IUPMn3rR7FJoc6VuTKKkefT8IcEONwSbPYqKIi7Dv7f8CkWq4r
Vc4I/sB7WS34UOPKjk+EQNddRj25g3zI/Ff57EMUt81WsTV89HywIHrDZa/1Axnq
kDl+HN3nt94ptBQnBMzPYAV+9+2q3auQ7zTtZu0GHY9/49Z3IJJAMxg9MTek4vi1
AXuV0YpYf2ExU13odNxJpyR0DTcML+wQ3JH8AVyZliVu2Qiz5DhSk2E1/1+LhwA8
nveZLZ8RZdDIDBBDNApAJfSRRv5AKcEGRjLL1sMix5c0TarHE58LcPN9wAMH7ufx
KrU+Xem8Q+23EA81yMgbP1f/33mj8RzLR4oBL3xiacsAl/tHlKH/kVjAUCOAggJH
eOqm/E2EVxI=
=1v4F
-----END PGP SIGNATURE-----

--Apple-Mail=_740B886B-92C7-4B32-8221-08D49D933AD6--
