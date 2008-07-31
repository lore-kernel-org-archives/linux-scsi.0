From: Daniel Dickinson <cshore@fionavar.ca>
Subject: Re: [Bugme-new] [Bug 11194] New: megraid_mbox kernel panic during
 st driver initialization
Date: Thu, 31 Jul 2008 16:00:44 -0400
Message-ID: <20080731160044.1d26e530@brennin.fionavar.dd>
References: <bug-11194-10286@http.bugzilla.kernel.org/>
	<20080731104810.9e18c749.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wM_1jZ=QVt1GyFrwrU+.6zY";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server01.gorrie.wightman.ca ([216.110.227.151]:37483 "EHLO
	mail.wightman.on.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750969AbYGaU1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 16:27:09 -0400
In-Reply-To: <20080731104810.9e18c749.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, megaraidlinux@lsi.com

--Sig_/wM_1jZ=QVt1GyFrwrU+.6zY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Jul 2008 10:48:10 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> >=20
> > Latest working kernel version: 2.6.24
> > Earliest failing kernel version: 2.6.26
>=20
> The kernel versions are ambiguous.
>=20
> Which is the earliest failing kernel version?

Sorry about that; I did latest failing (unless .27 is out; I haven't
tested it). Earliest failing is 2.6.25.

>=20
> > Distribution: Debian Lenny (-testing + -unstable + kernel trunk for
> > debian)
> >=20
> > Hardware Environment: ASUS P4B 2.0 GHz P4 Motherboard, Dell
> > PERC3/DC (like AMI MegraRAID Elite 1600) LVD Ultra3 SCSI Adaptor
> > with four 80 GB drives on Channel 0 and a SCSI-U2 Seagate DDS-4
> > tape drive on Channel 1 Software Environment:  Debian Lenny
> > (up-to-date), with some unstable and tested with the testing kernel
> > (.25) and the trunk kernel (.26)
> >=20
> > Problem Description: The kernel panics (claiming it's in the
> > megaraid_mbox driver) during boot when the st driver would normally
> > report=20
> >=20
> > st0: Block limits 1 - 16777215 bytes.
> >=20
> > This is after the logical disk has been found and all filesystems
> > mounted, so the RAID part of the driver is probably fine.
> >=20
> >=20
> > The point at which=20
> >=20
> > st 0:1:6:0: Attached scsi tape st0
> > st 0:1:6:0: st0: try direct i/o: yes (alignment 512 B)
> >=20
> > appears with .24 is passed before the panic, but I haven't actually
> > seen those messages as they scroll by too quickly.
> >=20
> > Steps to reproduce:
> >=20
> > 1) Install debian lenny with a .24 kernel (I'm not sure how you
> > would do that now that .24 is no longer the testing kernel); maybe
> > beta2 would still let you. 2) Install -testing kernel (.25)
> > 3) Attempt to boot using the new kernel
> > 4) Kernel panics, system is unusable
> >=20
>=20


--=20
And that's my crabbing done for the day.  Got it out of the way early,=20
now I have the rest of the afternoon to sniff fragrant tea-roses or=20
strangle cute bunnies or something.   -- Michael Devore
GnuPG Key Fingerprint 86 F5 81 A5 D4 2E 1F 1C      http://gnupg.org
No more sea shells:  Daniel's Weblog    http://cshore.wordpress.com

--Sig_/wM_1jZ=QVt1GyFrwrU+.6zY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiSGewACgkQhvWBpdQuHxzGwACghbqDtW91TghQAzwEYsPDsFzH
q04AmwRnoZTU3OIp3fTo1Fg7oE67Se4j
=KWw2
-----END PGP SIGNATURE-----

--Sig_/wM_1jZ=QVt1GyFrwrU+.6zY--
