From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 09/11] qla4xxx: Added support for ISP82XX
Date: Thu, 29 Apr 2010 08:17:20 +0200
Message-ID: <201004290817.20849.eike-kernel@sf-tec.de>
References: <20100428061431.GA11197@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8720594.RBHlKAN4z1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:45621 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454Ab0D3XCS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Apr 2010 19:02:18 -0400
In-Reply-To: <20100428061431.GA11197@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

--nextPart8720594.RBHlKAN4z1
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Am Mittwoch 28 April 2010 08:14:31 schrieb Vikas Chaudhary:

> diff --git a/drivers/scsi/qla4xxx/Kconfig b/drivers/scsi/qla4xxx/Kconfig
> index 69cbff3..b309851 100644
> --- a/drivers/scsi/qla4xxx/Kconfig
> +++ b/drivers/scsi/qla4xxx/Kconfig
> @@ -3,5 +3,5 @@ config SCSI_QLA_ISCSI
>  	depends on PCI && SCSI && NET
>  	select SCSI_ISCSI_ATTRS
>  	---help---
> -	This driver supports the QLogic 40xx (ISP4XXX) iSCSI host
> -	adapter family.
> +	This driver supports QLogic 40xx (ISP4XXX) as well as
> +	8022(ISP80XX) based adapter.

Here is a space missing.

Eike

--nextPart8720594.RBHlKAN4z1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvZJHAACgkQXKSJPmm5/E7V9ACdElLqDzTCVyGThJoD4oxjdfkp
ZbYAoIfoF/tMcV8NAti4wKGIEkbloukP
=yJnl
-----END PGP SIGNATURE-----

--nextPart8720594.RBHlKAN4z1--
