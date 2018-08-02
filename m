From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for Aug 1
Date: Thu, 2 Aug 2018 10:05:05 +1000
Message-ID: <20180802100505.56e663cb@canb.auug.org.au>
References: <20180801175852.36549130@canb.auug.org.au>
        <20180801224813.GA13074@roeck-us.net>
        <1533163965.3158.1.camel@HansenPartnership.com>
        <1533164454.3158.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.Gc82QXuAsDKDAkLmVLH09."; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533164454.3158.3.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Sig_/.Gc82QXuAsDKDAkLmVLH09.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 01 Aug 2018 16:00:54 -0700 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> So what seems to be happening to cause this is that there's a patch
> somewhere between the merge base of my scsi-next series and the next
> tree and the patch just before scsi-next was actually merged that
> actually causes a boot failure with blk-mq enabled.  Could you try to
> find this patch?  I think the way to do it is to try to bisect this
> range of linux-next using the command line
>=20
> scsi_mod.use_blk_mq=3D1
>=20
> Which forces block mq to be the default and seeing where the first boot
> failure is (you don't need my scsi-next tree merged to do this because
> all the offending patch does is flip the default state of the above
> flag).

So this means using v4.8-rc1 as the first good commit and 453f1d821165
("Merge remote-tracking branch 'cgroup/for-next'") as the first bad
(assuming that this latter fails to boot with "scsi_mod.use_blk_mq=3D1").

--=20
Cheers,
Stephen Rothwell

--Sig_/.Gc82QXuAsDKDAkLmVLH09.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAltiSrEACgkQAVBC80lX
0GxqyAf9GEnk3PtbKGKuCpu3gU6yYxkBLE3UQNOQ2NEa+W1HXoNRNU6zFlv6kc/A
3iUTIpRY4YexnVw31f/qSVx/hbBjeslZ53zwAUL5bObMGMSxz5Ot+tvjH0It5Rwv
HbJ0MhG4Zs5mybjTBFUupfqyx0V3ttS96UpcfXda6kV0AMFUhB1WAJchMwPpMVcb
rbi++FUOSlrckC/pgND5IYXcXebBYZB/WDwaQA8Tt+ZfLLbEuMA0LEH55LIUU4KM
ivzSwf6czB8dotUJQ1mfoPX1AijHWA6XrR+g871fjzvG4MJ3xNllqo8qzRDvFHmS
Pd9ST22I2bmuMJIKZvbK2MvE/XUQaQ==
=UEl/
-----END PGP SIGNATURE-----

--Sig_/.Gc82QXuAsDKDAkLmVLH09.--
