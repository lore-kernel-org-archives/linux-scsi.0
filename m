From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Next March 25: Boot failure on powerpc [recursive locking
 detected]
Date: Fri, 27 Mar 2009 16:56:24 +1100
Message-ID: <20090327165624.47a29945.sfr@canb.auug.org.au>
References: <20090325191229.0e17eaf6.sfr@canb.auug.org.au>
	<49CA3BF4.3050801@in.ibm.com>
	<49CB2200.50703@in.ibm.com>
	<1238075403.3342.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Mar_2009_16_56_24_+1100_cOldlwHN2s6RDN+i"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1238075403.3342.1.camel@localhost.localdomain>
Sender: linux-next-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Sachin Sant <sachinp@in.ibm.com>, linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Fri__27_Mar_2009_16_56_24_+1100_cOldlwHN2s6RDN+i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 26 Mar 2009 08:50:03 -0500 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> On Thu, 2009-03-26 at 12:04 +0530, Sachin Sant wrote:
> > Sachin Sant wrote:
> > > Today's next failed to boot on a powerpc box
> > > (Power6 blade IBM,7998-61X) with following recursive locking message.
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [ INFO: possible recursive locking detected ]
> > > 2.6.29-next-20090325 #1
> > After bisecting the failure seems to be because of the following
> > patch from James ( block: move SCSI timeout check into block )
> >=20
> > http://patchwork.kernel.org/patch/8017/
> >=20
> > If i back out the above mentioned patch, the machine boots fine
> > without any problems.
>=20
> Yes, that patch already got dropped for other reasons:
>=20
> http://marc.info/?t=3D123740773700002
>=20
> I'm going to see if I can redo it in a better way, since moving this
> type of timeout checking from scsi to block is a useful generalisation.

I will revert it from next-20090327 as well as it is still in the
for-next branch of the block tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Mar_2009_16_56_24_+1100_cOldlwHN2s6RDN+i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknMaokACgkQjjKRsyhoI8wU/ACfVogt2CorBOZeNDRe9Q+V8h7d
vJkAoKTDmMySZdADARicPv1iJc1tAyD4
=FSQo
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Mar_2009_16_56_24_+1100_cOldlwHN2s6RDN+i--
