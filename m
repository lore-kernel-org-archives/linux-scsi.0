From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH:
	usb-storage-set-last-sector-bug-flag.patch
Date: Fri, 25 Jan 2008 11:23:23 -0800
Message-ID: <20080125192323.GN14375@one-eyed-alien.net>
References: <20080120205625.GB28842@kroah.com>
	<Pine.LNX.4.44L0.0801201642460.8504-100000@netrider.rowland.org>
	<20080123181239.GA21836@kroah.com>
	<4798C5B4.1000208@s5r6.in-berlin.de>
	<20080124172158.GC9665@kroah.com>
	<1201281141.3119.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0316979467=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1201281141.3119.41.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Alan Stern <stern@rowland.harvard.edu>, Hans de Goede <j.w.r.degoede@hhs.nl>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org


--===============0316979467==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m+jEI8cDoTn6Mu9E"
Content-Disposition: inline


--m+jEI8cDoTn6Mu9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

ACKed-by: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Matt

On Fri, Jan 25, 2008 at 11:12:21AM -0600, James Bottomley wrote:
> On Thu, 2008-01-24 at 09:21 -0800, Greg KH wrote:
> > On Thu, Jan 24, 2008 at 06:07:00PM +0100, Stefan Richter wrote:
> > > Greg KH wrote:
> > > > I just am worried that we are
> > > > now suddenly keeping access from the last sector for devices that
> > > > currently did work just fine.
> > >=20
> > > This new workaround doesn't prevent access to the last sector.  It on=
ly
> > > breaks up a multi-sector access which would also reach the last sector
> > > into several (two? I'm too lazy to look back in the mail thread)
> > > accesses, in order to access the last sector in a dedicated
> > > single-sector access.
> > >=20
> > > So that's very differently to the fix-capacity workaround.  The
> > > fix-capacity workaround manipulates the READ CAPACITY parameter data.
> > > Therefore the fix-capacity workaround is unsafe for non-buggy devices.
> > >=20
> > > The last-sector-(access-)bug workaround _only_ modifies the command
> > > stream which is sent to the device.  A dangerous command is replaced =
by
> > > equivalent safe commands.  These commands are luckily safe for _all_
> > > devices, buggy and non-buggy ones.  The only cost of this workaround =
is
> > > (1.) the code, (2.) the runtime/ bandwidth/ latency overhead for
> > > accesses which reach the last sector.
> >=20
> > Ok, thanks for explaining it better.  I have no objection to this change
> > anymore.
>=20
> So, for forms sake to take this through the SCSI tree I need at least
> one USB person to ack it ...
>=20
> James
>=20

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--m+jEI8cDoTn6Mu9E
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHmjcrHL9iwnUZqnkRAr5kAJ0T+qAm+f4KfmtC0ZGyzTe67POXagCdHzvz
6RT2RUVTCS+mBiC1dWvwGcM=
=7+Tq
-----END PGP SIGNATURE-----

--m+jEI8cDoTn6Mu9E--


--===============0316979467==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
--===============0316979467==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============0316979467==--
