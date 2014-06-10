From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Tue, 10 Jun 2014 21:52:17 +1000
Message-ID: <20140610215217.495d5476@canb.auug.org.au>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
	<20140609133026.GA6239@redhat.com>
	<1402383912.5774.13.camel@haakon3.risingtidesystems.com>
	<20140610094254.GC7423@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ThYEsc89gXigJ78rv+7__C3"; protocol="application/pgp-signature"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140610094254.GC7423@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-scsi@vger.kernel.org

--Sig_/ThYEsc89gXigJ78rv+7__C3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Tue, 10 Jun 2014 12:42:54 +0300 "Michael S. Tsirkin" <mst@redhat.com> wr=
ote:
>
> So I see two options:
> - I go ahead with my changes and you with yours and let Linus resolve
>   the conflict.  This means bisect build will be broken since the
>   breakage will likely not be noticed until after the merge.

Well, since the resolution is known, the one who submits their tree
later should tell Linus (as suggested by Nicholas).  That is part of
the point of the linux-next tree ... and therefore there would be no
bisect problem.

> > Stephen (CC'ed) has included a fix in today's linux-next for the merge
> > conflict here:
> >=20
> > https://lkml.org/lkml/2014/6/10/3
> >=20
> > Please confirm, as it will be a pointer to Linus within the
> > target-pending/for-next PULL request.
>=20
> Yes but this does mean people trying to bisect will
> hit build breakages, not nice.

Not necessarily.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ThYEsc89gXigJ78rv+7__C3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTlvF4AAoJEMDTa8Ir7ZwV3YQP/jP1akYuVZavQwSyl49bbgqR
8XKak5rbTBJ0vfHliuA3KA7MORYJno27Rsy+vrgLX1ZA/+fJCaLUMrrI8RNQGOWK
UukwLwM7Aj/ZHP+AAyLYy3jmFzFkBLH6IKDxsyuhl0vPsz8duauN0G/95q3ZWW60
0g3v6pR73IFveoXuQ81Kcqgvx20Ga/h9EwpzCB2BKjb4WveAMKYhZUWYcS2rpIlb
gfmV14k7Z9QwuBES37hz8N4h3/hpA0kDqytYw4hWgbitEzX1uB/OcX024ZlPzh26
yHpMhzW5R/8/Atxt9tY5vg+v2GF3cfQXY6ycfnvz8k+JCSSIjS/QspTN20XwsMce
P/580eWHWi2OMjfEadYp9XAHxVvRK1wXI/mEwa6I9OMQuCYIMlInIo7RhAM6jsJt
OimSOeQP+VgTHdpaEl3ahJQsXb+OUBiGryESI2/HIooDO98X2T6qAfASN/YMzUsS
P57vNLwygStfn3q+his+vjWvFwwxccuQLne0CRC61WdTlxwdOm8hzFAZvAE1UEsR
42c6iHDL7Ab+maYD1n6REZgyQNuOMOBswyfNiiuOuwULlKNeCYq3M9N/NIlogzct
QUJp/Em0jyJpj0u1e3yTMeBleJlxt/Rvx4YvAD0HmAHgoVczNQ+E9ohe+0W/1Lws
6QDemhNls9eS71ThHHKf
=XJpz
-----END PGP SIGNATURE-----

--Sig_/ThYEsc89gXigJ78rv+7__C3--
