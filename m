From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Wed, 12 Nov 2003 16:09:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031112160921.A10818@one-eyed-alien.net>
References: <20031112155029.A20986@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:35858 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261762AbTKMAJZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Nov 2003 19:09:25 -0500
Content-Disposition: inline
In-Reply-To: <20031112155029.A20986@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Nov 12, 2003 at 03:50:29PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2003 at 03:50:29PM -0800, Patrick Mansfield wrote:
> James - can you please apply? This should not affect other devices since
> we are not changing the requested length, just the size of the receive
> buffer.

This is a terrible idea.

There is a large number of devices which choke if those two values do not
match.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Hi.  I have my back hairs caught in my computer fan.
					-- Customer
User Friendly, 8/20/1998

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/ssuxIjReC7bSPZARAgrDAKDIMFrlXAEQgHl8IwJF17KbQkWjWQCgvymC
O7D9aI6abLVQyTbVMv/+Was=
=CiE9
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
