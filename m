From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: Fw: gdth SCSI driver(?) fails with more than 4GB of memory
Date: Tue, 8 Aug 2006 10:49:26 +0200
Message-ID: <200608081049.26951.eike-kernel@sf-tec.de>
References: <20060717184659.04ae83e7.akpm@osdl.org> <200607180840.11877.eike-kernel@sf-tec.de> <20060807152606.GR18390@mails.so.argh.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2958623.XxpAeVQYrN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:36241 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932531AbWHHIrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2006 04:47:42 -0400
In-Reply-To: <20060807152606.GR18390@mails.so.argh.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Barth <aba@not.so.argh.org>
Cc: linux-scsi@vger.kernel.org

--nextPart2958623.XxpAeVQYrN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> With this patch, it returns now:
> SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
> sda: Write Protect is off
> sda: got wrong page (expect: 0x8, got 0x0)
> sda: assuming drive cache: write through
> SCSI device sda: 143299800 512-byte hdwr sectors (73369 MB)
> sda: Write Protect is off
> sda: got wrong page (expect: 0x8, got 0x0)

> If you rather want your patch alone, please tell me.)

No, it's ok this way. This way we just get a little more information.

Eike

--nextPart2958623.XxpAeVQYrN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBE2FAWXKSJPmm5/E4RAmCIAJ9jpaMmJTsvO3VChlWUcsqRDJFqxQCfTDC9
nQQgogn98Ad7j+WeaC7Okeo=
=qsLN
-----END PGP SIGNATURE-----

--nextPart2958623.XxpAeVQYrN--
