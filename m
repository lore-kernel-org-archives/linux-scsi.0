From: Kurt Garloff <kurt@garloff.de>
Subject: Re: Fwd: 32bit dev_t
Date: Thu, 23 Jan 2003 19:31:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030123183131.GA2126@nbkurt.garloff.de>
References: <3E2DC21D.9010204@torque.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E2DC21D.9010204@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Doug,

On Wed, Jan 22, 2003 at 08:56:45AM +1100, Douglas Gilbert wrote:
> This post appeared recently on the linux kernel list.
> What is the maximum number of disks that can be attached
> in lk 2.5? Is it 256 (double the number of SCSI disk majors)
> or larger. I remember Richard Gooch's "sd-many" patch
> was rejected for 2.5 because it was said there was a
> better mechanism around the corner.

I'm also still waiting for the dev_t changes to port my 2.4 patches to
support many hard disks (2k) to 2.5.
Maybe the port should just be started now?
Any taker? (I'm a bit short on time, so it won't happen before mid Feb
if I have to do it myself.)

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+MDUCxmLh6hyYd04RAhpHAKCQc2DEiZxv3sF06nBVDNut9ylYrwCgpKb5
zc56gc9UJ7ILeLzH/N4Mpc0=
=q1WP
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
