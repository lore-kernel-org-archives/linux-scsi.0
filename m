From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [SPAM] Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 14:04:03 -0700
Message-ID: <20060626210403.GA31085@one-eyed-alien.net>
References: <20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	<20060625224631.GD1608@parisc-linux.org>
	<1151310285.3185.16.camel@laptopd505.fenrus.org>
	<20060626124001.GG1608@parisc-linux.org>
	<20060626144442.GA13319@one-eyed-alien.net>
	<1151348151.4936.8.camel@fc5.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1776464104=="
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1151348151.4936.8.camel@fc5.xsintricity.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Doug Ledford <dledford@xsintricity.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Patrick Mansfield <patmans@us.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org


--===============1776464104==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 26, 2006 at 02:55:50PM -0400, Doug Ledford wrote:
> On Mon, 2006-06-26 at 07:44 -0700, Matthew Dharm wrote:
>=20
> > As for using one Scsi_Host... there are several usb-storage devices whi=
ch
> > attach to an entire SCSI bus (not just a single target), so can't make =
each
> > device it's own target.
>=20
> This makes no sense to me at all.  The USB devices attach to a USB bus,
> the whole notion of a SCSI bus for USB devices is as nothing more than
> an abstraction, and should be able to be arbitrarily changed in the USB
> stack any time you wish.  In short, you aren't doing SCSI selections
> over a USB bus, so why should SCSI target IDs vs. host IDs matter?
> Aren't they just all mapped in the driver to the USB device anyway?

I guess my point is that there are some devices for which the concept of a
'bus' is -not- an abstraction.  These devices have a USB connector at one
end and a SCSI HD-68 connector on the other, and can be attached to 15
devices in a SCSI chain.

Perhaps I misunderstand your objection?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

E:  You run this ship with Windows?!  YOU IDIOT!
L:  Give me a break, it came bundled with the computer!
					-- ESR and Lan Solaris
User Friendly, 12/8/1998

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFEoEvDHL9iwnUZqnkRAkaQAKCdOPIXYYkA4gZ7SOZTuxXgL9WC1ACfVA3t
yDk6vIe21mDjn+YmY3tAmss=
=vmS7
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--


--===============1776464104==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642

--===============1776464104==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
Linux-hotplug-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel

--===============1776464104==--
