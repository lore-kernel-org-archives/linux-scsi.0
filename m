From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 1/1] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver
Date: Wed, 11 Jun 2008 17:18:19 +0200
Message-ID: <200806111718.20087.eike-kernel@sf-tec.de>
References: <200806102250.m5AMoZdK007621@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2217411.mL0YSoWYsj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:53305 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYFKPZU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2008 11:25:20 -0400
In-Reply-To: <200806102250.m5AMoZdK007621@d03av04.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com

--nextPart2217411.mL0YSoWYsj
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> +	vhost->trace = kzalloc(sizeof(struct ibmvfc_trace_entry) *
> +			       IBMVFC_NUM_TRACE_ENTRIES, GFP_KERNEL);

Use kcalloc() here.

Eike

--nextPart2217411.mL0YSoWYsj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIT+y8XKSJPmm5/E4RAsI3AJ0XO8m1MWcadlW9wEypK7XC+WU+ZQCfeDIk
C3I1/ksU/95+jhfO1UilOis=
=nXmf
-----END PGP SIGNATURE-----

--nextPart2217411.mL0YSoWYsj--
