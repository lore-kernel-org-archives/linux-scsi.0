From: Kurt Garloff <garloff@suse.de>
Subject: Re: SCSI Command scatter-gather number
Date: Tue, 30 Jul 2002 23:33:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020730213316.GB6505@nbkurt.etpnet.phys.tue.nl>
References: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A678@nonamea.ptu.promise.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A678@nonamea.ptu.promise.com>
List-Id: linux-scsi@vger.kernel.org
To: Haofeng Kou <haofengk@ptu.promise.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Haofung,

On Tue, Jul 30, 2002 at 02:07:49PM -0700, Haofeng Kou wrote:
> For the "struct scsi_cmnd", there is a member :
> 	unsigned short use_sg;
> Which gives the Number of pieces of the scatter-gather.
>=20
> How to limit its value, how to set the max value for the "use_sg"?

For a low-level driver you mean?
Use the sg_tablesize field.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9RwYbxmLh6hyYd04RAgA5AJ0eUtyfH0EcWc2zlFoZbAI/bwqJZwCffMWV
pXaUi9vMcAmwrutadGCWxOk=
=B9lK
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
