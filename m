From: Kurt Garloff <kurt@garloff.de>
Subject: [garloff@suse.de: Re: [linux-usb-devel] Re: /proc/scsi/map]
Date: Mon, 17 Jun 2002 03:24:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020617012400.GH21461@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrvsYIebpInmECXG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.name>
Cc: dougg@torque.net, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, David Brownell <david-b@pacbell.net>, Andries.Brouwer@cwi.nl, sancho@dauskardt.de, linux-usb-devel@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net


--lrvsYIebpInmECXG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

forgot to Cc: the other recipients.=20
I did not want to turn this into a private discussion.

----- Forwarded message from Kurt Garloff <garloff@suse.de> -----

Date: Mon, 17 Jun 2002 02:46:24 +0200
From: Kurt Garloff <garloff@suse.de>
To: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: /proc/scsi/map
In-Reply-To: <200206162314.g5GNEYf03058@localhost.localdomain>
User-Agent: Mutt/1.4i
X-Operating-System: Linux 2.4.16-schedJ2 i686
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E, 1024R/CEFC9215
Organization: TU/e(NL), SuSE(DE)

Hi,

On Sun, Jun 16, 2002 at 06:14:33PM -0500, James Bottomley wrote:
> oliver@neukum.name said:
> > But the drivers already know, or would have to be taught to know about
> > it. Somewhence that information has to come. You cannot avoid that
> > effort.=20
>=20
> Not necessarily: consider the SCSI WWN, which is supported by most modern=
 SCSI=20
> devices.  The driver never probes for or asks for this.  Nowhere in the=
=20
> current SCSI code do we ask for this.  However user level commands (like=
=20
> sg_inq) can formulate the 0x83 page inquiry to get this and return the ou=
tput.=20
>  This works today with the current driver.

This may work for your disks. You just can't open the device node for a
tape, if there is no medium inserted. If you know the mapping between
to a sg device you can use it.
That's the second piece of information that /proc/scsi/map provides.

The first piece is that the kernel tells kernel tells you the way it is
attached by reporting CBTU, which is a good identifier for good old parallel
SCSI that most of our SCSI code still is assuming.

That will change one day ...

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)



----- End forwarded message -----

--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--lrvsYIebpInmECXG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9DTowxmLh6hyYd04RAs67AKDBXY5QmjAbMrcmSa5daNC9pwo4vQCbBkI8
H5gRp7qlMaMOTul7Me/N3wM=
=/oHf
-----END PGP SIGNATURE-----

--lrvsYIebpInmECXG--
