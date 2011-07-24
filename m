From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT PULL] iscsi-target merge for v3.1-rc1
Date: Sun, 24 Jul 2011 12:27:37 +1000
Message-ID: <20110724122737.fbc4996c6a3a285972a1529f@canb.auug.org.au>
References: <1311462975.31450.356.camel@haakon2.linux-iscsi.org>
	<20110723163338.f8c08cf8.akpm@linux-foundation.org>
	<1311466763.31450.364.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__24_Jul_2011_12_27_37_+1000_2p3Z6GqjtcfVmN=e"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311466763.31450.364.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <openosd@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Sun__24_Jul_2011_12_27_37_+1000_2p3Z6GqjtcfVmN=e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

On Sat, 23 Jul 2011 17:19:23 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi=
.org> wrote:
>
> On Sat, 2011-07-23 at 16:33 -0700, Andrew Morton wrote:
> > On Sat, 23 Jul 2011 16:16:15 -0700 "Nicholas A. Bellinger" <nab@linux-i=
scsi.org> wrote:
> >=20
> > > So in the spirit of timely pull requests ahead of your upcoming summer
> > > vacation, here is the long awaited and much debated initial merge com=
mit
> > > for v3.1-rc1 of drivers/target/iscsi to sync with latest bleeding edge
> > > LIO v4.1 codebase.
> >=20
> > None of this is in linux-next?  How did that happen?
>=20
> I am happy to start using linux-next for target-pending.git mainline
> items, but unfortuately these have yet to see direct linux-next testing
> just yet..
>=20
> Stephen, would you pretty please add target-pending.git/for-next into
> linux-next build testing..?

Sure, just send me the url of the git tree (and branch) and I will add it
tomorrow (assuming this is stuff still destined for v3.1 - stuff for v3.2
sould wait until after v3.1-rc1).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__24_Jul_2011_12_27_37_+1000_2p3Z6GqjtcfVmN=e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOK4MZAAoJEDMEi1NhKgbsUe8H/i/55Irh71aw3nWwkLMRtVeO
Ks3KCmabS0Og8jH5CrohEx6QdC7GYb1UvDblX/Ez000ru/jnko9OUPGQ95w1LDTO
WHwFHgf61X9ZV0b0UpAiFhMhgM/Tnw1DSIPaJdivCCITuPJNbsgB/QN6YVRb9Sid
1DAMh+Ktx7SrFHlZzwpSUsdYW9P6omDP/AttXMbM8k9Yp8atkKxTOOOxrrsRIpGN
hfk72k+C5HsSttu4wIhFdyEVen+SSmJz4c65Zibuafq1hbVbFxN5cI+/xD560fzD
J3ubItqVQ8HMyulGEB5r/yHsnRKFjLJbJkUfjp9/cIdxYGpwXCkpuSR6f07c1/E=
=cVYY
-----END PGP SIGNATURE-----

--Signature=_Sun__24_Jul_2011_12_27_37_+1000_2p3Z6GqjtcfVmN=e--
