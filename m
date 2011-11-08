From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
Date: Tue, 8 Nov 2011 11:36:20 +1100
Message-ID: <20111108113620.de7ba0673df6aa9d8f3a2111@canb.auug.org.au>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
	<1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
	<20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Nov_2011_11_36_20_+1100_nD57gtFFJ4w9+04z"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Tue__8_Nov_2011_11_36_20_+1100_nD57gtFFJ4w9+04z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Nov 2011 11:03:00 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Mon, 07 Nov 2011 08:51:24 -0600 James Bottomley <James.Bottomley@Hanse=
nPartnership.com> wrote:
> >
> > Actually, I don't think it's anything to do with this: it's Anton's
> > fault
> >=20
> > commit f7c9c6bb14f3104608a3a83cadea10a6943d2804
> > Author: Anton Blanchard <anton@samba.org>
> > Date:   Thu Nov 3 08:56:22 2011 +1100
> >=20
> >     [SCSI] Fix block queue and elevator memory leak in scsi_alloc_sdev
> >=20
> > Doesn't completely do the teardown.  The true fix is to do a proper
> > teardown instead of hand rolling it.  Does this fix it for you?
>=20
> I don't get the WARNING any more, but now get lots of:
>=20
> scsi: killing requests for dead queue

also, ipr_init takes 494857993 usecs(!) which is a bit suboptimal.  And I
get a few

INFO: rcu_sched detected stall ...

while ipr_init is in progress.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Nov_2011_11_36_20_+1100_nD57gtFFJ4w9+04z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuHmEAAoJEECxmPOUX5FEmkEP/iHLmzjrTFNrCCfZaHXwR+t6
b957TJfV1EFzCq+Uc7gTgHK2di3RNvw4OcjeqSNSZ2bq68q6aCamLYIqxSEciwPW
XrbfjL8V8RWDQAT5M0ia8poqpQ/AFln1P9Jgo23o4EYB8Zsqlp40ZDburcePfQze
kLRWEFeYiFriJLvlPuKPycfrHWJ+PBqUBQl/IdLSpZQCsW6ZbVN4CTk8Rqb1Zie8
obN+nhDP7BD5e1dnAX/DeAO62FcqKynVBhO+kzihflcNqCbiQuP4FNfRqsIVQebc
lmiIQOiqjo8GXYtU3LDhkcIlNlakLbeRATS8bv/7QW/2/O1Qx1NWrcZvQWrcT+Vf
dhIwfI8utLVnLvo3MGjFY4lh90D5H/Yq2gdb5KbBKjCWVEwTO5CMVnMjmpWzpVxs
V2ViCxwSA4rCX55b//adh4LbHdlUsMsmvktvaEzC+eqjH+/+URxrAOojpVzE9YUu
qm3+XfD1zbmlODtolpArmdvEW3PSsO36TocZ4C1tDEeQhIyrSdaOnJLJPlkG6yez
ApJn8lmRIRmuMHJclksfRuktqUkhWqYDohE+05DpzfNSoHSgke4V9VPa8dvSs9JN
opqqxIhDCS7xl2Tg/zdF/GXPQlr1Eq8gCgzuhbeqfzCXNcRuKklmU7W30DjUxObv
9f/iXgbG4YpMGVMaasjc
=/0Qm
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Nov_2011_11_36_20_+1100_nD57gtFFJ4w9+04z--
