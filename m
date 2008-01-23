From: Phil Dibowitz <phil@ipom.com>
Subject: Re: [PATCH] [2.6.23.13] udev hangs USB-storage
 (HP r707 camera)
Date: Wed, 23 Jan 2008 00:50:00 -0800
Message-ID: <4796FFB8.1030503@ipom.com>
References: <20080119174556.GE11553@colo.lackof.org>
	<47929B9F.8080607@s5r6.in-berlin.de>
	<20080120022829.GG11553@colo.lackof.org>
	<1200797791.11214.3.camel@localhost.localdomain>
	<20080120031008.GI11553@colo.lackof.org>
	<1200802265.11214.8.camel@localhost.localdomain>
	<20080120052553.GA5452@colo.lackof.org> <4796D02D.8000108@ipom.com>
	<20080123065556.GB20348@colo.lackof.org>
	<20080123070229.GC20348@colo.lackof.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0647863592=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080123070229.GC20348@colo.lackof.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Grant Grundler <grundler@parisc-linux.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============0647863592==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigE245D77024C7E41ECD983C46"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE245D77024C7E41ECD983C46
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Grant Grundler wrote:
> On Tue, Jan 22, 2008 at 11:55:56PM -0700, Grant Grundler wrote:
> ...
>>>   http://www.phildev.net/linux/usb-unusualdevs-notes.html
>> In general, a very helpful document! Thanks!
> ...
>=20
> I read the rest of the document and explains exactly my confusion.
> Can you please include that document into Documentation/usb/ ?
> And then add a reference to the location where the US_SC* and US_PR*
> constants are defined?

They moved since I wrote that document with the birth of libusual.

include/linux/usb_usual.h is where you can find them. I'll try to get aro=
und
to updating that doc sometime soon.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming



--------------enigE245D77024C7E41ECD983C46
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHlv+4N5XoxaHnMrsRAkqyAJ99HHKMMRKBPs16bbWI9mWhb35iWQCdEPOm
I6e70LRcaEE6nv40KNZndW8=
=Ll6Y
-----END PGP SIGNATURE-----

--------------enigE245D77024C7E41ECD983C46--


--===============0647863592==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
--===============0647863592==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============0647863592==--
