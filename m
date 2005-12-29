From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Thu, 29 Dec 2005 08:45:16 +0100
Message-ID: <200512290845.17192@bilbo.math.uni-mannheim.de>
References: <1135801791.9541.12.camel@gateway.markschaefer.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2325329.3DqnzuOCAL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:10408 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S932575AbVL2Hp2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Dec 2005 02:45:28 -0500
In-Reply-To: <1135801791.9541.12.camel@gateway.markschaefer.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Schaefer <mark@markschaefer.org>
Cc: linux-scsi@vger.kernel.org

--nextPart2325329.3DqnzuOCAL
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Mark Schaefer wrote:
>Hi,
>
>I have a couple of these arrays I purchased from eBay.  Apparently, they
>don't work with any other controller card, except cpqfc, which is
>unsupported in the 2.6 kernel.  Has anyone gotten these working on a
>different card?  If so, is it possible to boot off of this array?  I'm
>using Emulex LP8000's, but have the 64-bit/66MHz Compaq cards for
>configuration.
>
>	James Bottomley mentioned that it supported the SCC-2 spec, which is
>now deprecated, and reading the spec, it seems as though I wouldn't be
>able to boot directly from the array.
>
>Thanks in advance for any pointers.

I'm now quoting mkp:

=2D--
But the other reason the cpqfcTS driver is special is the RA4100
array. =A0The two were sold as a packaged solution. =A0The RA4100 isn't a
"real" fibre channel disk device. =A0It represents itself as a TYPE_RAID
as opposed to TYPE_DISK. =A0So even if you had my driver in 2.6.5, you
wouldn't be able to use it.
=2D--

What he was talking about as his driver is a replacement he writes for cpqf=
c.=20
cpqfc was deleted from 2.6 because it was horribly written and currently=20
broken. The 2.4 version is the same, but it might work because the 2.4=20
infrastructure is different from the 2.6 one.

Eike

--nextPart2325329.3DqnzuOCAL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDs5QNXKSJPmm5/E4RAtzAAJ4v+PI2EJF1RON9/P1DHMsR4/UWbwCeLseu
pWaJa6OxzqJqkws82iY3skM=
=zprp
-----END PGP SIGNATURE-----

--nextPart2325329.3DqnzuOCAL--
