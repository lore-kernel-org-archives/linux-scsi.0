From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Wed, 23 Apr 2003 17:10:02 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030423171002.A14203@one-eyed-alien.net>
References: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <UTC200304232239.h3NMdSf07801.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Thu, Apr 24, 2003 at 12:39:28AM +0200
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com
List-Id: linux-scsi@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2003 at 12:39:28AM +0200, Andries.Brouwer@cwi.nl wrote:
> Comments?

My only comment is that your sample of failed cases primarily seems to
address those devices that support some variant of MODE_SENSE -- there are
lots of devices that don't support it at all, which is why I wanted to
filter it with the (apparently) now-dead command filter concept.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It's not that hard.  No matter what the problem is, tell the customer=20
to reinstall Windows.
					-- Nurse
User Friendly, 3/22/1998

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pytaIjReC7bSPZARAsCrAKC898Vqc6qtkj81VKOLwoVi/9+alwCgkZqo
cu13qUcPQUnw4yuYWSEI5qw=
=Mum0
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--


-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
