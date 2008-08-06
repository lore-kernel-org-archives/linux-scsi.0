From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Date: Wed, 6 Aug 2008 13:08:25 +1000
Message-ID: <20080806130825.1567d882.sfr@canb.auug.org.au>
References: <20080730211842.GF1758@roadking.ldev.net>
	<20080804095633.GA20055@kernel.dk>
	<20080805153012.0076396e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Aug_2008_13_08_25_+1000_EoiQWEE+oMeG+/bQ"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764043AbYHFDIz@vger.kernel.org>
In-Reply-To: <20080805153012.0076396e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, mike.miller@hp.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Wed__6_Aug_2008_13_08_25_+1000_EoiQWEE+oMeG+/bQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Aug 2008 15:30:12 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> I'm not seeing these changes in linux-next nor in
> master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#for-=
next
> nor in #for-akpm.

Well linux-next gets its block tree from
git://git.kernel.dk/linux-2.6-block.git#for-next (which appears to be
very similar - if not identical to - the above).

> Also, #for-next is empty, but #for-akpm has the single commit

The for-linus branch seems to have a few commits, though ...
Jens, would you like that in linux-next as block-current (merged early -
meant for bug fixes destined for the current release)?

>         vmsplice: implement real vmsplice to userspace

Yeah, that looks way to scary for linux-next :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Aug_2008_13_08_25_+1000_EoiQWEE+oMeG+/bQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiZFakACgkQjjKRsyhoI8ySKgCfcnVYVDm9vas+wVlY5CBBqg1i
bYkAnjg0gCMJI1r8WdrJ1Un1iAmaVfD8
=s7Kl
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Aug_2008_13_08_25_+1000_EoiQWEE+oMeG+/bQ--
