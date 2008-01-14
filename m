From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: usb-storage-psc1350-v4.patch (was
	Linux scsi /	usb-mass-storage and HP printer cardreader bug + fix)
Date: Mon, 14 Jan 2008 08:03:10 -0800
Message-ID: <20080114160310.GH14375@one-eyed-alien.net>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>
	<4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>
	<4787CE08.5000304@hhs.nl> <1200303645.11301.15.camel@littletux>
	<478B2F90.7010105@hhs.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0611255343=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <478B2F90.7010105@hhs.nl>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Guillaume Bedot <littletux@zarb.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, fedora-kernel-list@redhat.com, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org


--===============0611255343==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DWg365Y4B18r8evw"
Content-Disposition: inline


--DWg365Y4B18r8evw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 14, 2008 at 10:46:56AM +0100, Hans de Goede wrote:
> Guillaume Bedot wrote:
> >But it fixes only two models.
> >Do you think other devices (hp or not) can be impacted ?
> >There are hundreds of models with card readers only for hp :
> >http://hplip.sourceforge.net/supported_devices/combined.html
> >
> >Will this be possible to use "LAST_SECTOR_BUG" quirk for testing without
> >recompiling a kernel ?
> >
>=20
> This is not possible AFAIK, I've already wrote a blog post about this=20
> asking for people to test this, but got no responses.

Once the patches are accepted by the SCSI people, one of the things we can
consider doing is enabling this quirk for all USB devices.  It should be
pretty harmless to all properly working devices, and the performance hit
should be pretty minimal.

We may be able to convince the SCSI people to enable it for all devices,
regardless of HCD.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What the hell are you?
					-- Pitr to Dust Puppy=20
User Friendly, 12/3/1997

--DWg365Y4B18r8evw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHi4e+HL9iwnUZqnkRAl10AJ4rD0jIuqneWfQC/4rUBZBJRNI5kACgnTUB
bOV7So8UBN5jQLAPP/+i7jY=
=1teA
-----END PGP SIGNATURE-----

--DWg365Y4B18r8evw--


--===============0611255343==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
--===============0611255343==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============0611255343==--
