From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 24 Mar 2003 12:20:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324122050.C1066@one-eyed-alien.net>
References: <0FA2250F5A23D64FBD983956F9B2864301ED5277@royntex01.iomegacorp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0FA2250F5A23D64FBD983956F9B2864301ED5277@royntex01.iomegacorp.com>; from LAVARRE@iomega.com on Mon, Mar 24, 2003 at 12:16:29PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <LAVARRE@iomega.com>
Cc: dougg@torque.net, Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2003 at 12:16:29PM -0700, Pat LaVarre wrote:
> In particular, passing CDB's thru sg will mark them
> Required, until/ unless we rev sg to let its client
> choose to say Required or not?

That was my intent, at least.  The assumption being that a userspace
program should have done an INQUIRY for 36-bytes to determine if it knows
what it's about to do is safe.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Pitr!  That's brilliant!  Funded by Microsoft refunds.  What sweet irony!
					-- A.J.
User Friendly, 2/15/1999

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+f2iiIjReC7bSPZARArTOAJ9phczDBgvoFXREUqqqGjBFflQbIgCgvA+L
9f6aT3hkpxE8b4df1X7OUNE=
=esYH
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
