From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [RFC] [PATCH 0/5] qla4xxx: Add IPv6 support and misc
Date: Thu, 3 May 2007 14:38:57 +0200
Message-ID: <200705031439.05500.eike-kernel@sf-tec.de>
References: <1178157870.20898.35.camel@iscsi-sles10> <4639CAB5.7090308@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1454928.FfxWEWcl8b";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:35008 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031302AbXECMpy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 May 2007 08:45:54 -0400
Received: from  ([::ffff:212.65.3.74] HELO donald.sf-tec.de) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Thu, 03 May 2007 14:39:12 +0200
In-Reply-To: <4639CAB5.7090308@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, David C Somayajulu <david.somayajulu@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, David Wagner <david.wagner@qlogic.com>

--nextPart1454928.FfxWEWcl8b
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Stefan Richter wrote:
> David C Somayajulu wrote:
> > The following set of patches
> >         1. add support for ipv6 for qla4032
> >         2. provide bug fixes
> >         3. misc. support

> [...]
>
> I have no technical comments, just a formal one:
>
> Even though you perhaps don't expect the patches to be committed as-is,
> you should give each patch an own descriptive patch title (instead of
> naming them all "qla4xxx: Add IPv6 support and misc").  Also, you could
> put the above descriptions into the individual patch descriptions.

And sending [n/5] as reply to [0/5] keeps the inbox more readable :)

Eike

--nextPart1454928.FfxWEWcl8b
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGOdfpXKSJPmm5/E4RAuOmAKCibiPONolAUMHLt0S3qSdd2zQXSACggojk
nWflJYx8rsLgqPS8RcG0who=
=XmAy
-----END PGP SIGNATURE-----

--nextPart1454928.FfxWEWcl8b--
