From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.20
Date: Mon, 12 Feb 2007 11:29:28 +0100
Message-ID: <200702121129.34359.eike-kernel@sf-tec.de>
References: <1171166252.3373.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6168428.fcT4MqvegJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964840AbXBLK2x@vger.kernel.org>
Received: from  ([::ffff:212.65.3.74] HELO donald.sf-tec.de) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Mon, 12 Feb 2007 11:28:48 +0100
In-Reply-To: <1171166252.3373.58.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

--nextPart6168428.fcT4MqvegJ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Sonntag, 11. Februar 2007 schrieb James Bottomley:
> This is the accumulated SCSI tree for 2.6.20.  It is available at
>
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

You once again have not included this two patches Andrew sent you on 20070602:

[patch 08/33] remove extra newline from info message
[patch 09/33] Fix scsi/scsi_transport.h compile error

Is this by mistake or intentional?

Greetings,

Eike

--nextPart6168428.fcT4MqvegJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF0EGOXKSJPmm5/E4RAsAlAJ9yb3XOlBjnW0kzrZLIizALmhkGSwCfTY44
Ia3MPYEcPZEZ8nLQBEleiLM=
=rOAz
-----END PGP SIGNATURE-----

--nextPart6168428.fcT4MqvegJ--
