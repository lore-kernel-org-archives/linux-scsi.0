From: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [Bugme-new] [Bug 8885] New: Unable to access
 memory card reader anymore
Date: Tue, 14 Aug 2007 06:45:09 +0200
Message-ID: <20070814064509.01ff5b2c@poseidon.drzeus.cx>
References: <bug-8885-10286@http.bugzilla.kernel.org/>
	<20070813201354.baffcaba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1026223654=="
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070813201354.baffcaba.akpm@linux-foundation.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, casteyde.christian@free.fr, linux-kernel-announce@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--===============1026223654==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg=PGP-SHA1;
	boundary="=_hera.drzeus.cx-15667-1187066709-0001-2"

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-15667-1187066709-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2007 20:13:54 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

>=20
> I'm struggling a bit to work out if this is a scsi bug, a USB bug, an
> MMC bug or whatever.  But it's a bug.
>=20

I can't see anything MMC related in his dmesg, only what seems to be a
USB based reader:

scsi 0:0:0:0: Direct-Access     Generic  Flash R/W        2002 PQ: 0
ANSI: 2

Rgds
Pierre

--=_hera.drzeus.cx-15667-1187066709-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGwTNV7b8eESbyJLgRAhfMAJ93vgjghvxbiUZHCsOcXlyvzF9aSQCgtm9w
c/1iVpD5jEz05Eh5J7IckPQ=
=5e3q
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-15667-1187066709-0001-2--


--===============1026223654==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
--===============1026223654==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--===============1026223654==--
