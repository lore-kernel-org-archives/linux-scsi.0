From: Pavel Machek <pavel@ucw.cz>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 20:56:15 +0200
Message-ID: <20170508185615.GA16268@amd>
References: <alpine.DEB.2.11.1705080930150.6882@lnxricardw1>
 <1494231215.6528.22.camel@infradead.org>
 <alpine.DEB.2.11.1705081034420.6882@lnxricardw1>
 <1494233673.6528.28.camel@infradead.org>
 <alpine.DEB.2.11.1705081059580.6882@lnxricardw1>
 <7ee84982-cfad-94d7-4e22-4edbeb852b32@redhat.com>
 <1494238390.6528.42.camel@infradead.org>
 <20170508135005.0b9b200b@bbrezillon>
 <20170508164322.GA9781@amd>
 <20170508174303.GA12079@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170508174303.GA12079@htj.duckdns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>, David Woodhouse <dwmw2@infradead.org>, Hans de Goede <hdegoede@redhat.com>, Ricard Wanderlof <ricard.wanderlof@axis.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
List-Id: linux-scsi@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-05-08 13:43:03, Tejun Heo wrote:
> Hello,
>=20
> On Mon, May 08, 2017 at 06:43:22PM +0200, Pavel Machek wrote:
> > What I was trying to point out was that storage people try to treat
> > SSDs as HDDs... and SSDs are very different. Harddrives mostly survive
> > powerfails (with emergency parking), while it is very, very difficult
> > to make SSD survive random powerfail, and we have to make sure we
> > always powerdown SSDs "cleanly".
>=20
> We do.
>=20
> The issue raised is that some SSDs still increment the unexpected
> power loss count even after clean shutdown sequence and that the
> kernel should wait for some secs before powering off.
>=20
> We can do that for select devices but I want something more than "this
> SMART counter is getting incremented" before doing that.

Well... the SMART counter tells us that the device was not shut down
correctly. Do we have reason to believe that it is _not_ telling us
truth? It is more than one device.

SSDs die when you power them without warning:
http://lkcl.net/reports/ssd_analysis.html

What kind of data would you like to see? "I have been using linux and
my SSD died"? We have had such reports. "I have killed 10 SSDs in a
week then I added one second delay, and this SSD survived 6 months"?


									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkQv08ACgkQMOfwapXb+vJ7wgCeL/J3nQGv1XJXJNORb75vfoZW
XAAAoJGe8JZ5+VwTW+7DQPp3e46K9TcJ
=rPcK
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
