From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sun, 27 Apr 2003 12:52:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427125237.A23693@one-eyed-alien.net>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl> <20030426151356.A8697@one-eyed-alien.net> <1051397024.4089.86.camel@mulgrave> <20030426183428.B8697@one-eyed-alien.net> <1051409717.4089.146.camel@mulgrave> <20030427023517.A15212@one-eyed-alien.net> <1051458107.2427.25.camel@fuzzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:19724 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261605AbTD0Tk0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 15:40:26 -0400
Content-Disposition: inline
In-Reply-To: <1051458107.2427.25.camel@fuzzy>; from James.Bottomley@steeleye.com on Sun, Apr 27, 2003 at 10:41:45AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 27, 2003 at 10:41:45AM -0500, James Bottomley wrote:
> So the algorithm is quite simple: you get the command length from the
> group (using a table with one exception for the 32 byte commands), and
> then extract the transfer length from the command

I'm with you up to about this point.

So tell me how many bytes my command wanted to move?  READ_10 specifies the
transfer length is 'blocks'.  How many bytes are in a block is
device-dependent.

Some commands (i.e. INQUIRY) specify transfer length in bytes.  Others
(i.e. READ_10) specify it in blocks, and the size of a block is not known
based simply on the current command.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Okay, this isn't funny anymore! Let me down!  I'll tell Bill on you!!
					-- Microsoft Salesman
User Friendly, 4/1/1998

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rDUFIjReC7bSPZARAmzQAKDWtKz8jswaDdTty0QywrmS15yCmQCePAXC
XerpfUusGhhsgIe/jnXcbXk=
=g79X
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
