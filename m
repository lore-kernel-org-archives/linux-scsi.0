From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] deinline some functions in aic7xxx drivers, save 80k of text
Date: Mon, 10 Apr 2006 09:19:19 +0200
Message-ID: <200604100919.23244.eike-kernel@sf-tec.de>
References: <200604100844.12151.vda@ilport.com.ua> <200604100903.35431.eike-kernel@sf-tec.de> <200604101015.36869.vda@ilport.com.ua>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1735792.7TOZKksDQo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751067AbWDJHXS@vger.kernel.org>
In-Reply-To: <200604101015.36869.vda@ilport.com.ua>
Sender: linux-kernel-owner@vger.kernel.org
To: Denis Vlasenko <vda@ilport.com.ua>, SCSI List <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, gibbs@scsiguy.com
List-Id: linux-scsi@vger.kernel.org

--nextPart1735792.7TOZKksDQo
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[Full quote and readded CC adresses. My fault, pressed wrong button]

Denis Vlasenko wrote:
> On Monday 10 April 2006 10:03, Rolf Eike Beer wrote:
> > Am Montag, 10. April 2006 07:49 schrieben Sie:
> > > On Monday 10 April 2006 08:44, Denis Vlasenko wrote:
> > > > I also spotted two bugs in the process, patches
> > > > for those will follow.
> > >
> > > ahd_delay(usec) is buggy. Just think how would it work
> > > with usec == 1024*100 + 1...
> >
> > This is unneeded. The biggest argument this function is ever called with
> > is 1000.
>
> I know.
>
> > I would suggest to delete this function completely. If one ever has to
> > wait for a longer period mdelay() is the right function to call.
>
> I am leaving it up to maintainer to decide. After all, the driver
> is for multiple OSes, other OS may lack mdelay().

The comment says about multiple milliseconds sleeps which just don't happen.

Eike

--nextPart1735792.7TOZKksDQo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBEOgb7XKSJPmm5/E4RAk+TAJwPY+pGOAZUzzOkosqbBp10V/1PDwCfRqba
uZjUfV17FHWkHwIpV9B5WZ4=
=3QeF
-----END PGP SIGNATURE-----

--nextPart1735792.7TOZKksDQo--
