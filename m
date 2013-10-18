From: Robert Story <rstory@tislabs.com>
Subject: Re: kernel cant access SATA adapter device
Date: Fri, 18 Oct 2013 14:53:21 -0400
Message-ID: <20131018145321.3d60711b@kvm171.vb.futz.org>
References: <20131016154651.7280ce92@kvm171.vb.futz.org>
	<20131017155924.GA31331@taco-ThinkPad-X220>
	<20131017130249.4a49bd46@kvm171.vb.futz.org>
	<20131018143745.GA2615@taco-ThinkPad-X220>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Pqs0r/nmbh+8texiHPMfY/7"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from walnut.tislabs.com ([192.94.214.200]:49248 "EHLO
	walnut.tislabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3JRSx1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2013 14:53:27 -0400
In-Reply-To: <20131018143745.GA2615@taco-ThinkPad-X220>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: taco <tacoee@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--Sig_/Pqs0r/nmbh+8texiHPMfY/7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Oct 2013 22:37:45 +0800 taco wrote:
T>=20
T> reproduce the problem with more debug messages with the bellow
T> command:
T>=20
T> $ echo 0x2FFFF > /sys/modules/mptsas/mpt_debug_level
T>=20
T> and attach it here

The dmesg buffer wrapped, and it was close to 500k. That's a bit big for
sending to the whole list, so I put it and the syslog output on my
webserver:

   http://futz.org/users/linux-scsi/mpt.messages
   http://futz.org/users/linux-scsi/mpt.dmesg=20


Robert

--
Senior Software Engineer
Parsons Government Services , National Security & Defense Division

--Sig_/Pqs0r/nmbh+8texiHPMfY/7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlJhg6YACgkQ7/fVLLY1mnjAzwCePsgfWFS2fRizY8Z0Y2jzg4DO
vjgAn1wNmJDSgdzft+iJM447pxh8xQw2
=0lp/
-----END PGP SIGNATURE-----

--Sig_/Pqs0r/nmbh+8texiHPMfY/7--
