From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Sat, 22 Feb 2003 23:48:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030222234834.A32167@one-eyed-alien.net>
References: <20030124214831.GA28812@redhat.com> <20030124152540.B27859@one-eyed-alien.net> <20030125000529.GE28812@redhat.com> <20030124164553.C27859@one-eyed-alien.net> <20030125010729.GG28812@redhat.com> <20030202101317.A26796@one-eyed-alien.net> <20030202120628.A28024@one-eyed-alien.net> <20030203171726.GA1583@beaverton.ibm.com> <20030216131835.B23422@one-eyed-alien.net> <20030217193737.GB1990@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030217193737.GB1990@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, Feb 17, 2003 at 11:37:37AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Okay, I see Linus has now accepted this into his tree.  It should propagate
to the USB development trees soon.

One question: What else is needed?  We set the device offline,
error/complete all pending commands, and the need to (somehow) make certain
we're in a good state for calling scsi_remove_host().  How do we make that
final guarantee?

There was talk that scsi_set_device_offline() would take care of that for
us by waking up the error handler... there seems to be code to do that....

There was talk of using the release() function from the SCSI template to
actually release resources....

So, what's the plan?

Matt


On Mon, Feb 17, 2003 at 11:37:37AM -0800, Mike Anderson wrote:
> Matthew Dharm [mdharm-scsi@one-eyed-alien.net] wrote:
> > Any updates on this?  I saw some patches, but they don't seem to be in =
my
> > tree (the usb tree, which is synced from Linus' tree).
> >=20
> > People are starting to reports OOPSes to me because of this being
> > missing....
> >=20
> > Matt
> >=20
>=20
> The scsi_set_device_offline interface is part of the last patch (scsi
> error) I sent to linux-scsi. I updated my patch post some comments from
> the list, but I am working on issue with the patch before I resend.
>=20
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

But where are the THEMES?!  How do you expect me to use an OS without=20
themes?!
					-- Stef
User Friendly, 10/9/1998

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+WHzSIjReC7bSPZARAsj9AKCyySwDsJ9NK8d4YW4ozryjxXEgNwCg0h7Z
DlCY1M6azQrfSt7BJfAK22I=
=lrpx
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
