From: Kurt Garloff <kurt@garloff.de>
Subject: Re: Task Sets in SCSI and Linux
Date: Wed, 8 May 2002 20:29:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020508202901.B23476@gum01m.etpnet.phys.tue.nl>
References: <200205081634.g48GYe304381@localhost.localdomain> <2D7BA26D-62A8-11D6-8C21-0003934B22FE@infiniconsys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2D7BA26D-62A8-11D6-8C21-0003934B22FE@infiniconsys.com>
List-Id: linux-scsi@vger.kernel.org
To: Michael Heinz <mheinz@infiniconsys.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Wed, May 08, 2002 at 01:22:31PM -0400, Michael Heinz wrote:
> You confused me with this - my testing with 2.4 seems to indicate that=20
> SCSI won't queue up more than one command per LUN (that is, it waits for=
=20
> one command to complete before issuing the next). How can I tell it to=20
> do otherwise? (It allows parallel commands, as long as they are going to=
=20
> different LUNs). I didn't see anything in the SHT to indicate otherwise.

Your host adapter driver and your device need to support Tagged Command
Queueing and it needs to be enabled. The Linux SCSI layer will make use of
it.=20

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE82W5rxmLh6hyYd04RAhhvAJ4zzOq8W6r1pl3SDK51d+vYl8HNxACfSYN0
roIypZQM043tk1Vizm4IV0Q=
=eCJu
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
