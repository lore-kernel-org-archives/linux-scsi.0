From: Kurt Garloff <garloff@suse.de>
Subject: Re: Fwd: 32bit dev_t
Date: Fri, 24 Jan 2003 09:20:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030124082035.GA3243@nbkurt.garloff.de>
References: <3E2DC21D.9010204@torque.net> <20030123183131.GA2126@nbkurt.garloff.de> <20030123221805.A2468@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030123221805.A2468@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christpoh,

On Thu, Jan 23, 2003 at 10:18:05PM +0000, Christoph Hellwig wrote:
> On Thu, Jan 23, 2003 at 07:31:31PM +0100, Kurt Garloff wrote:
> the Linux 2.5 sd and sr drivers are only limited by the number of majors
> allocated to them.  There's no more architectural limit or any global
> array.

In the 2.4 patches I allocate majors dynamically.[1]
I was expecting that that part of the patch would need to be rewritten
for 2.5.=20
And of course sysfs, once it is complete (i.e. include char devices)
would replace the device reporting hack.

[1] http://www.suse.de/~garloff/linux/scsi-many/

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+MPdSxmLh6hyYd04RAutJAJ9wz6wcrUHkztLGMzi/z+K7/sDz9wCfWFov
fRi801ptCYpatlEPbhqrY5g=
=l7r6
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
