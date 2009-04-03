From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: scsi tree build failure
Date: Fri, 3 Apr 2009 11:26:02 +1100
Message-ID: <20090403112602.fa3010c8.sfr@canb.auug.org.au>
References: <20090402164927.97958f84.sfr@canb.auug.org.au>
	<1238682141.3383.11.camel@mulgrave.int.hansenpartnership.com>
	<1238692778.15031.56.camel@fritz>
	<1238696622.13399.11.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Apr_2009_11_26_02_+1100_PHOPr34U9s=VW=0h"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1238696622.13399.11.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Robert Love <robert.w.love@intel.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "Dev, Vasu" <vasu.dev@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--Signature=_Fri__3_Apr_2009_11_26_02_+1100_PHOPr34U9s=VW=0h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 02 Apr 2009 18:23:42 +0000 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> On Thu, 2009-04-02 at 10:19 -0700, Robert Love wrote:
> >
> > I built using gcc version 4.3.2 (on x86_64) and didn't see this either.

It may be powerpc specific, I guess.

> > > diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> > > index 5cdda6e..94e1e31 100644
> > > --- a/drivers/scsi/fcoe/fcoe.c
> > > +++ b/drivers/scsi/fcoe/fcoe.c
> > > @@ -979,7 +979,6 @@ u32 fcoe_fc_crc(struct fc_frame *fp)
> > >  	}
> > >  	return crc;
> > >  }
> > > -EXPORT_SYMBOL_GPL(fcoe_fc_crc);
> > > =20
> > >  /**
> > >   * fcoe_xmit() - FCoE frame transmit function
> > >=20
> > >=20
> Right at the moment, I need someone to verify that this is the fix,
> since I don't have a complaining compiler myself.  If it's this simple,
> I can adjust the patch accordingly.

This fixes it for me.  I will apply that patch to linux-next for today
(instead of the reverts I did yesterday).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Apr_2009_11_26_02_+1100_PHOPr34U9s=VW=0h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknVV5oACgkQjjKRsyhoI8z/RACgjt5Or6luGEVmZ9yt49NBrg49
bFIAoJhiFOOGrkmyus7A9N9f9Q67d5Jd
=AKGi
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Apr_2009_11_26_02_+1100_PHOPr34U9s=VW=0h--
