From: Paul Wagland <paul@wagland.net>
Subject: Re: assertion failure with new megaraid beta driver leads to sche duling failure
Date: Fri, 16 Apr 2004 07:44:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2E7711F2-8F69-11D8-8B4A-000A95CD704C@wagland.net>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC533@exa-atlanta.se.lsil.com>
Mime-Version: 1.0 (Apple Message framework v613)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-8-707877079"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out2.xs4all.nl ([194.109.24.12]:7942 "EHLO
	smtp-out2.xs4all.nl") by vger.kernel.org with ESMTP id S262416AbUDPFpW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 01:45:22 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC533@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>, Sreenivas Bagalkote <sreenib@lsil.com>, Linux kernel mailing list <linux-kernel@vger.kernel.org>


--Apple-Mail-8-707877079
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; format=flowed

Atul,

On Apr 16, 2004, at 0:36, Mukker, Atul wrote:

> Paul,
>
> Random deletion has issues with this version of the driver. Sreenivas 
> will
> release the next version tomorrow morning with the fix.

As I understand it you want this new driver to replace the one in the 
kernel, correct?

If so, would it be possible to rename the output file to megaraid.o, 
instead of megaraid_nm.o. The reason for this is that then the various 
vendor tools that produce initrd images would then most likely not need 
to be changed.

If not, then a new name is good ;-)

Cheers,
Paul

--Apple-Mail-8-707877079
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)

iD8DBQFAf3LXtch0EvEFvxURAjApAKCoXzm0reXD0RrAsthl8F/IJGTXmACgyPov
FdMC9l/QcdGCEbkHjHOWDTE=
=jVIJ
-----END PGP SIGNATURE-----

--Apple-Mail-8-707877079--

