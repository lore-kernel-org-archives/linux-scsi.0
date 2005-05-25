From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: [PATCH RFC 2/2] implement transport scan callout for iscsi
Date: Wed, 25 May 2005 09:00:39 -0400
Message-ID: <1117026039.5527.28.camel@localhost.localdomain>
References: <42936441.0b798bab.39a4.ffff9774SMTPIN_ADDED@mx.googlegroups.com>
	 <42939610.3070104@cs.wisc.edu> <1116976678.7710.34.camel@mulgrave>
	 <000b01c560c0$42c59700$03031eac@ivivity.com>
	 <1116982816.7710.58.camel@mulgrave>
	 <001101c560c9$0870f280$03031eac@ivivity.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sY27RdO4Z9BUYY8BE4pY"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:61322 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S262268AbVEYNAq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 09:00:46 -0400
In-Reply-To: <001101c560c9$0870f280$03031eac@ivivity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi <open-iscsi@googlegroups.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>


--=-sY27RdO4Z9BUYY8BE4pY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

about this 400K IOPS, both ini and target are using your HW solution?

ming

On Tue, 2005-05-24 at 21:28 -0400, open_iscsi wrote:
> Regarding the numbers, we get 400,000 IOPS with our hardware solution
> using=20
> multiple connections and multiple micro-engines. I have not tried=20
> multi-pathing but I can tell you that I had to count clocks to get
> that=20
> number and found that even a few extra clocks could mean a lot. So
> since=20
> multi-pathing takes a lot of extra clocks, then I think there is a
> benefit.=20
> However with a software solution the extra clocks for the multi-
> pathing may=20
> not be significant.

--=-sY27RdO4Z9BUYY8BE4pY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBClHb3SYbkL5BnVYoRAr9oAJ9rurZgGp/TfuwLJFTSwLGv4xPLXwCfeOhw
OJ0r6chXmYKENQcdbLbTBwg=
=MNpf
-----END PGP SIGNATURE-----

--=-sY27RdO4Z9BUYY8BE4pY--

