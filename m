From: Valdis.Kletnieks@vt.edu
Subject: Re: 3.2.0-rc3-next-20111128 lockdep splat during boot..
Date: Wed, 30 Nov 2011 18:59:32 -0500
Message-ID: <28342.1322697572@turing-police.cc.vt.edu>
References: <23526.1322620187@turing-police.cc.vt.edu>
            <201112010017.19156.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1322697572_2875P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: Your message of "Thu, 01 Dec 2011 00:17:18 +0100."
             <201112010017.19156.rjw@sisk.pl>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--==_Exmh_1322697572_2875P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 Dec 2011 00:17:18 +0100, "Rafael J. Wysocki" said:
> On Wednesday, November 30, 2011, Valdis.Kletnieks@vt.edu wrote:
> > Seen this twice out of two boots while initrd was waiting for me to
> > enter the passphrase for encrypted LVM.  No idea *who* to toss this
> > one at - got ACPI, PM, SCSI and vtconsole all listed in tracebacks, so
> > I'm tossing this at everybody and hope it sticks. ;)
> 
> This was caused by one of my patches in linux-next and was linux-next-only.
> 
> I've already replaced the offending patch with a new version.

OK, thanks.

--==_Exmh_1322697572_2875P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO1sNkcC3lWbTT17ARApziAJ4xipIL+k6xkkdghUHcg5YTqMcCtQCeOWJ3
nb56IOqtP6pioI7BGhCg+c8=
=hnPv
-----END PGP SIGNATURE-----

--==_Exmh_1322697572_2875P--

