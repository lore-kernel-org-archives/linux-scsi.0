From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Wed, 26 Feb 2003 17:10:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226171043.F28571@one-eyed-alien.net>
References: <20030125000529.GE28812@redhat.com> <20030124164553.C27859@one-eyed-alien.net> <20030125010729.GG28812@redhat.com> <20030202101317.A26796@one-eyed-alien.net> <20030202120628.A28024@one-eyed-alien.net> <20030203171726.GA1583@beaverton.ibm.com> <20030216131835.B23422@one-eyed-alien.net> <20030217193737.GB1990@beaverton.ibm.com> <20030222234834.A32167@one-eyed-alien.net> <20030226233702.GC1376@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="L2Brqb15TUChFOBK"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030226233702.GC1376@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Feb 26, 2003 at 03:37:02PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>


--L2Brqb15TUChFOBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2003 at 03:37:02PM -0800, Mike Anderson wrote:
> There still are a few things on the to do list, but should not effect the
> LLDD interface (at least this is the goal).
> 	- scsi_request_fn needs a fix for device offline that will
> 	  handle all request types.
> 	- scsi_remove_host needs to call template release at the correct
> 	  time (ref counting ??).
> 	- need fix for offline hotplug event.
> 		- Should do_hotplug be exported or should device states
> 		  be added / fixed ??

Right... but I removed the release() function because that was marked (in
the documentation) as only for the old-style drivers.  So I'll need to
re-introduce it -- but it looks like all it has to do is free some memory.
Does that sound about right?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Da.  Am thinkink of carbonated borscht for lonk nights of coding.
					-- Pitr
User Friendly, 7/24/1998

--L2Brqb15TUChFOBK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XWWTIjReC7bSPZARAt0EAKCKCctoYlUQiA7OAg4pZFZyX42CqwCgixZn
Ta7BwhOrU1rPTi6rAiPVPUI=
=uGc+
-----END PGP SIGNATURE-----

--L2Brqb15TUChFOBK--
