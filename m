From: Kurt Garloff <garloff@suse.de>
Subject: scsi_host/host0/device/name gone :-(
Date: Mon, 5 Jan 2004 10:48:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040105094852.GK6671@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n83H03bbH672hrlY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:21434 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263205AbUAEJsx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2004 04:48:53 -0500
Received: from Hermes.suse.de (Hermes.suse.de [195.135.221.8])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by Cantor.suse.de (Postfix) with ESMTP id B61A2198FF7C
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2004 10:48:52 +0100 (CET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>


--n83H03bbH672hrlY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

in previous releases of pre-2.6 kernels, there existed
/sys/class/scsi_host/host0/device/name
indicating the host name of a host adapter.
This has been used in scsidev to collect information about devices
and to build persistent device names.

In 2.6.0, this seems to be gone. Has this piece of information been
removed on purpose? Where can it be found in sysfs now?=20

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--n83H03bbH672hrlY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD4DBQE/+TMDxmLh6hyYd04RApxgAJd2H2GRtmDXIKp60pEJPQqh7H1hAJ4jC4rk
HAWThjhMN6u8yXB9qwT+VA==
=ur8M
-----END PGP SIGNATURE-----

--n83H03bbH672hrlY--
