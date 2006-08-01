From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/6] lpfc 8.1.7 : Fix failing firmware download due to mailbox delays needing to be longer
Date: Tue, 1 Aug 2006 14:20:41 +0200
Message-ID: <200608011420.41752.eike-kernel@sf-tec.de>
References: <1154432023.18162.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2334868.gEFiF2BJJz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:20938 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751297AbWHAMTZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 08:19:25 -0400
In-Reply-To: <1154432023.18162.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: linux-scsi@vger.kernel.org

--nextPart2334868.gEFiF2BJJz
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

James Smart wrote:
> Fix failing firmware download due to mailbox delays needing to be longer.

>  		/* timeout active mbox command */
> -		mod_timer(&psli->mbox_tmo, jiffies + HZ * LPFC_MBOX_TMO);
> +		mod_timer(&psli->mbox_tmo, (jiffies +
> +			       (HZ * lpfc_mbox_tmo_val(phba, mb->mbxCommand))));
>  	}

In linux/jiffies.h there are some functions for converting jiffies to *secs=
=20
and back which you might find useful.

Eike

--nextPart2334868.gEFiF2BJJz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBEz0cZXKSJPmm5/E4RAtnWAJ4sKUE0bu8Zr3mtnPzC9FBoD4VbFgCfafkJ
UGsalKEnqZEI7K55/Em0q7Q=
=uqXc
-----END PGP SIGNATURE-----

--nextPart2334868.gEFiF2BJJz--
