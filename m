From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger receive buffer
Date: Thu, 13 Nov 2003 17:03:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031113170315.C30194@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org> <1068766632.2851.142.camel@patrh9>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:12037 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261661AbTKNBDZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 20:03:25 -0500
Content-Disposition: inline
In-Reply-To: <1068766632.2851.142.camel@patrh9>; from p.lavarre@ieee.org on Thu, Nov 13, 2003 at 04:37:12PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: stern@rowland.harvard.edu, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2003 at 04:37:12PM -0700, Pat LaVarre wrote:
> Maybe here I mean to ask: can we easily nutshell for me how well
> write-protect works now in sd?  I understand that we find mode sense of
> header alone and mode sense of xFF troublesome.

sd checks for write-protect status when it decides to 'revalidate' the
disk.  That means, basically, when the user has instructed the device to
eject media, or the device returns sense data indicating that media might
have changed.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/tCnTIjReC7bSPZARApMiAJ429vWDzQdXBz1vmhms+sYAfrXuAACfd39a
pNtTxxC10xaoupMKGA1byz4=
=w3m9
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
