From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] sd_many done right (5/5)
Date: Tue, 30 Jul 2002 13:16:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020730111617.GA1214@nbkurt.etpnet.phys.tue.nl>
References: <20020726154948.GH19721@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020726154948.GH19721@nbkurt.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>, Marcelo Tosatti <marcelo@conectiva.com.br>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2002 at 05:49:48PM +0200, Kurt Garloff wrote:
> The patch is against 2.4.19-rc1 with patch 1/5 (and optionally 2--4)=20
> applied. You will want to apply patch 4/5 (partition statistics) in order
> to avoid significant consumption of memory when using many disks.

Christoph Hellwig made me aware that the diff was not applying cleanly. Thx!
The reason was that I had the aa patches in my trees.
I rediffed against a clean rc3. New patches are available on
http://www.suse.de/~garloff/linux/scsi-many/

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                          Eindhoven, NL
GPG key: See mail header, key servers         Linux kernel development
SuSE Linux AG, Nuernberg, DE                            SCSI, Security

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9RnWBxmLh6hyYd04RAqj+AJ49a2+8QnpQCsQtyR/C1lAzWg+VWgCbBN8D
KkFpc0bOwZ1O+0EHrvdr6PY=
=RRzh
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
