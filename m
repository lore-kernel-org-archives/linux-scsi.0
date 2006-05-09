From: Alexander Gran <alex@zodiac.dnsalias.org>
Subject: Re: reiser4 bug [was Re: 2.6.17-rc3-mm1]
Date: Tue, 9 May 2006 02:13:03 +0200
Message-ID: <200605090213.06693@zodiac.zodiac.dnsalias.org>
References: <20060503210055.GB31048@beardog.cca.cpqcorp.net> <200605082246.50332@zodiac.zodiac.dnsalias.org> <20060508232159.13550.qmail@pv105234.reshsg.uci.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1648581.UYTTP183aE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-grafik.net ([80.237.205.72]:7185 "EHLO hs-grafik.net")
	by vger.kernel.org with ESMTP id S1750827AbWEIANL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2006 20:13:11 -0400
In-Reply-To: <20060508232159.13550.qmail@pv105234.reshsg.uci.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Feise <jfeise@feise.com>
Cc: Andrew Morton <akpm@osdl.org>, "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-list@namesys.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

--nextPart1648581.UYTTP183aE
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Nope, did not work...
regards
Alex

Am Dienstag, 9. Mai 2006 01:21 schrieb Joe Feise:
> Try the patch from here:
> http://marc.theaimsgroup.com/?l=3Dreiserfs&m=3D114709188305181&w=3D2
> That helped me get past the bootup phase (currently 8 hours uptime).
>
>  -Joe
>
> Alexander Gran writes:
> > Hi all,
> >
> > 2.6.17-rc3-mm1 doesn't get up running  here, it bugs around while init
> > runs: I cannot login afterwards, and syslog did not get the bug too. So
> > here are some poor screenshots from my Treo650 (digicam is broken,
> > sorry..;) EIP is in clear_inode.
> > Trace:
> > reiser4_delete_inode+0x6c/0xd0
> > d_delete+0xf0/0x10f
> > reiser4_delete_inode+0x0/0xd0
> > generic_delete_inode+0x6b/0xfb
> > input+0x5c/0x68
> > do_unlikat+0xd7/0x12c
> > sysenter_past_esp+0x54/0x75
> > __hidp_send_ctrl_message+0xb4/0xfa
> > details:
> > http://zodiac.dnsalias.org/images/1.jpg
> > http://zodiac.dnsalias.org/images/2.jpg
> > http://zodiac.dnsalias.org/images/3.jpg
> > http://zodiac.dnsalias.org/images/4.jpg
> > Kernel config:
> > http://zodiac.dnsalias.org/images/config
> > System is my T40p, as usual. running an up2date debian unstable.
> >
> > regards
> > Alex

=2D-=20
Encrypted Mails welcome.
PGP-Key at http://zodiac.dnsalias.org/misc/pgpkey.asc | Key-ID: 0x6D7DD291

--nextPart1648581.UYTTP183aE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBEX96S/aHb+2190pERAkqYAKCEGVy+bFPMln4XzGkkRFAe9oY4SwCfcqP1
A/aUMVJiBJK9ap/DEehvL3I=
=ivb2
-----END PGP SIGNATURE-----

--nextPart1648581.UYTTP183aE--
