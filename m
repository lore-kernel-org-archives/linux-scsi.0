From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Subject: Re: Feiya 5-in-1 Card Reader
Date: Wed, 4 Sep 2002 16:57:28 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20020904165728.P13478@one-eyed-alien.net>
References: <UTC200209042256.g84Mu0w15389.aeb@smtp.cwi.nl> <20020904161042.O13478@one-eyed-alien.net> <20020904234653.GB10227@win.tue.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="AwNVUpjOmSj7UnwZ"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20020904234653.GB10227@win.tue.nl>; from aebr@win.tue.nl on Thu, Sep 05, 2002 at 01:46:53AM +0200
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://www.geocrawler.com/redir-sf.php3?list=linux-usb-devel>
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org


--AwNVUpjOmSj7UnwZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Well, that's the best answer I've gotten so far.

I guess the patch can go in.

Matt

On Thu, Sep 05, 2002 at 01:46:53AM +0200, Andries Brouwer wrote:
> On Wed, Sep 04, 2002 at 04:10:42PM -0700, Matthew Dharm wrote:
>=20
> > I'm trying to find out why Windows doesn't choke on the strange
> > READ_CAPACITY value.
>=20
> That is an easy one.
> It belongs to the recent partitioning discussion on l-k.
>=20
> Windows knows the type of partition table, so reads the
> partition table and the boot sector and the FAT and is happy.
>=20
> Linux tries various things, depending on how you compiled your kernel,
> and among other things also needs to examine the last sector.
> So, only Linux will do bad things in case the capacity is off by one,
> and only when your config includes partitioning types that use this
> last sector.

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I don't have a left mouse button.  I only have one mouse and it's on my rig=
ht.
					-- Customer
User Friendly, 2/13/1999

--AwNVUpjOmSj7UnwZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9dp3oIjReC7bSPZARAmQGAJ9+Ev7EaANlreCGQYBEK5hGoiY6pACg0vnN
BdKpDRqrr0OaZLFsgg6Z20I=
=zdRR
-----END PGP SIGNATURE-----

--AwNVUpjOmSj7UnwZ--


-------------------------------------------------------
This sf.net email is sponsored by: OSDN - Tired of that same old
cell phone?  Get a new here for FREE!
https://www.inphonic.com/r.asp?r=sourceforge1&refcode1=vs3390
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
