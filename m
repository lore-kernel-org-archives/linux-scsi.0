From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 04/10] block: implement blk_rq_pos/[cur_]sectors() and
 convert obvious ones
Date: Thu, 30 Apr 2009 00:18:10 +1000
Message-ID: <20090430001810.56532d81.sfr@canb.auug.org.au>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
	<1240996428-10159-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Apr_2009_00_18_10_+1000_Q/N_cTYXHDeMPz2a"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1240996428-10159-5-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

--Signature=_Thu__30_Apr_2009_00_18_10_+1000_Q/N_cTYXHDeMPz2a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Apr 2009 18:13:42 +0900 Tejun Heo <tj@kernel.org> wrote:
>
>  drivers/block/viodasd.c         |    6 +++---

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Apr_2009_00_18_10_+1000_Q/N_cTYXHDeMPz2a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn4YaIACgkQjjKRsyhoI8z6NgCguZNob2wlgTAvYTg3ah/OkVmx
HvoAoJcf4e9uOB1DDN0or2FMJWCwOPkH
=+4Zr
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Apr_2009_00_18_10_+1000_Q/N_cTYXHDeMPz2a--
