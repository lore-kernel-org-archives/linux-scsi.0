From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: usb-storage-psc1350-v4.patch (was
	Linux scsi /	usb-mass-storage and HP printer cardreader bug + fix)
Date: Mon, 14 Jan 2008 11:01:05 -0800
Message-ID: <20080114190105.GJ14375@one-eyed-alien.net>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>
	<4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>
	<4787CE08.5000304@hhs.nl> <1200303645.11301.15.camel@littletux>
	<478B2F90.7010105@hhs.nl>
	<20080114160310.GH14375@one-eyed-alien.net>
	<1200328388.3159.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1800451602=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1200328388.3159.20.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Guillaume Bedot <littletux@zarb.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, fedora-kernel-list@redhat.com, Hans de Goede <j.w.r.degoede@hhs.nl>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org


--===============1800451602==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l06SQqiZYCi8rTKz"
Content-Disposition: inline


--l06SQqiZYCi8rTKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 14, 2008 at 10:33:08AM -0600, James Bottomley wrote:
>=20
> On Mon, 2008-01-14 at 08:03 -0800, Matthew Dharm wrote:
> > We may be able to convince the SCSI people to enable it for all devices,
> > regardless of HCD.
>=20
> No ... I'm not particularly keen to have enterprise vendors after my
> blood ...

Fair enough.  Tho, we should probably just enable this blindly for all
usb-storage devices.  Otherwise, this is just going to become an
unusual_devs.h nightmare.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--l06SQqiZYCi8rTKz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHi7FxHL9iwnUZqnkRApg2AKCh4mO+Qwu3TXqsT33CYbUsEFQzkgCfTM5l
KKiYugfESytoWV5Fa9G4pUQ=
=ZXe8
-----END PGP SIGNATURE-----

--l06SQqiZYCi8rTKz--


--===============1800451602==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
--===============1800451602==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============1800451602==--
