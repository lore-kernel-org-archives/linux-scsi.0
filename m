From: Kurt Garloff <garloff@suse.de>
Subject: Re: Fwd: 32bit dev_t
Date: Tue, 28 Jan 2003 16:19:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030128151946.GH3267@E2.suse.de>
References: <3E2DC21D.9010204@torque.net> <20030123183131.GA2126@nbkurt.garloff.de> <20030123221805.A2468@infradead.org> <20030124182952.GF20972@ca-server1.us.oracle.com> <20030127225125.A13617@infradead.org> <1043752867.1328.10.camel@dhcp22.swansea.linux.org.uk> <20030128112840.A27734@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8sldprk+5E/pDEv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030128112840.A27734@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joel Becker <Joel.Becker@oracle.com>, Douglas Gilbert <dougg@torque.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--a8sldprk+5E/pDEv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 28, 2003 at 11:28:40AM +0000, Christoph Hellwig wrote:
> On Tue, Jan 28, 2003 at 11:21:07AM +0000, Alan Cox wrote:
> > Which leaves the non trivial change of figuring out a usable security
> > model when doing that. I've yet to see one
>=20
> That's why I didn't implement it.  Ask the SuSE folks, they already ship
> the dynamic majors for sd hack in their 2.4-based tree.

You're supposed to use scsidev to create the device nodes beyond the
256 standard ones. It handles permissions. Based on CBTU addresses (or
optionally aliases that you may define using the serial no or WWID),
not the detection order.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers                 SuSE Labs (Head)
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--a8sldprk+5E/pDEv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+Np+SxmLh6hyYd04RAjcIAKCfkVtQny79Int7ecaInUn6elvolQCfTeJS
rCwdAxvHH+BdtsjPJBFVLsQ=
=yBH5
-----END PGP SIGNATURE-----

--a8sldprk+5E/pDEv--
