From: Rolf Eike Beer <eike@sf-mail.de>
Subject: Re: [PATCH] dont decrement counters from scsi_kill_request
Date: Wed, 4 Jan 2006 08:51:57 +0100
Message-ID: <200601040852.15700@bilbo.math.uni-mannheim.de>
References: <1136360688.9634.2.camel@max>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2264506.uLmzPTPvG2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:14024 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751199AbWADHwT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 02:52:19 -0500
In-Reply-To: <1136360688.9634.2.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

--nextPart2264506.uLmzPTPvG2
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Mike Christie wrote:

>+	while (end_that_request_first(req, 0, req->nr_sectors))
>+		;

This should be something like

while (...)
	{}

so it is absolutely clear that the empty body is intentional.

Eike

--nextPart2264506.uLmzPTPvG2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDu36vXKSJPmm5/E4RAveiAJ0VjkdT5QBL1acn1C7C5KKlFFcHqACeMefn
Y4CcpIwu9zUkr+azBs/tZU0=
=L9KF
-----END PGP SIGNATURE-----

--nextPart2264506.uLmzPTPvG2--
