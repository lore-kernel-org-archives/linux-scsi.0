From: Kurt Garloff <garloff@suse.de>
Subject: Re: Patch for 256 disks in 2.4
Date: Mon, 22 Jul 2002 23:12:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <30049.1388225511$1027372683@news.gmane.org>
References: <20020720195729.C20953@devserv.devel.redhat.com> <20020722170840.GB19587@nbkurt.etpnet.phys.tue.nl> <20020722164856.D19904@devserv.devel.redhat.com> <20020722215700.A12813@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wmhq21yAGFMoSpeN"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020722215700.A12813@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Pete Zaitcev <zaitcev@redhat.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>


--wmhq21yAGFMoSpeN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 22, 2002 at 09:57:00PM +0100, Christoph Hellwig wrote:
> I might be stupid, but it looks to me like we want both the new majors
> and the kernel structs dynamically allocated when they get actually used..

Sure. The sd dynamic major allocation uses the registered block majors firs=
t.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--wmhq21yAGFMoSpeN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9PHVTxmLh6hyYd04RAlZ+AJ0dmx0gx/KarV3JXhiZ229Dp4kYugCgy/DF
Dm83CXjG8zbSVJxMoZjvaF4=
=5RTx
-----END PGP SIGNATURE-----

--wmhq21yAGFMoSpeN--
