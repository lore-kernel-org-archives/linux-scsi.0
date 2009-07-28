From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/6] RFC: beiscsi : handles core routines
Date: Tue, 28 Jul 2009 15:13:37 +0200
Message-ID: <200907281513.46229.eike-kernel@sf-tec.de>
References: <20090728071251.GA13581@serverengines.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1698021.Ygp0EMzlQI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:57657 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbZG1NN7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jul 2009 09:13:59 -0400
In-Reply-To: <20090728071251.GA13581@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

--nextPart1698021.Ygp0EMzlQI
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Jayamohan Kallickal wrote:
>   Thie file handles initiallization/teardown, allocation/free as well
>   as IO/Management flows.
> +
> +static struct pci_driver beiscsi_pci_driver = {
> +	.name = "DRV_NAME",
            ^^^^^^^^^^
> +	.probe = beiscsi_dev_probe,
> +	.remove = beiscsi_remove,
> +	.id_table = beiscsi_pci_id_table
> +};

This is wrong for sure. Will look into the rest later.

--nextPart1698021.Ygp0EMzlQI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkpu+YoACgkQXKSJPmm5/E4BBwCeLjW7NmM0ZNfD4WxsqL7IvV5f
xiUAnimmX4UJm7LQWdn7ySd9FL6PjXC/
=8qSu
-----END PGP SIGNATURE-----

--nextPart1698021.Ygp0EMzlQI--
