From: Robert Story <rstory@tislabs.com>
Subject: Re: kernel cant access SATA adapter device
Date: Wed, 23 Oct 2013 12:23:38 -0400
Message-ID: <20131023122338.74493acf@ispx.vb.futz.org>
References: <20131016154651.7280ce92@kvm171.vb.futz.org>
	<20131017155924.GA31331@taco-ThinkPad-X220>
	<20131017130249.4a49bd46@kvm171.vb.futz.org>
	<20131018143745.GA2615@taco-ThinkPad-X220>
	<20131018145321.3d60711b@kvm171.vb.futz.org>
	<20131023160916.GA24189@taco-ThinkPad-X220>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mRY9=.YCENZnt=Du4.sowwQ"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from walnut.tislabs.com ([192.94.214.200]:33783 "EHLO
	walnut.tislabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3JWQXo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2013 12:23:44 -0400
In-Reply-To: <20131023160916.GA24189@taco-ThinkPad-X220>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: taco <tacoee@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--Sig_/mRY9=.YCENZnt=Du4.sowwQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Oct 2013 00:09:17 +0800 taco wrote:
T> Sense key [02 04 02] means LOGICAL UNIT NOT READY, INITIALIZING COMMAND
T> REQUIRED
T>=20
T> it works on windows but not on linux?

Yes, according to my coworker, Windows Embedded boots fine. And the
system boots via the card, with syslinux loading the kernel/initrd from the
card, so I don't know why it wouldn't be ready.

As I mentioned before, 'sdparm --command=3Dcapacity /dev/sda' initially
fails, but will succeed after 'sdparm --command=3Dstart /dev/sda'. However,
even though capacity works after the start command, attempts to access the
card continue to fail (e.g fdisk -l /dev/sda).


Robert

--
Senior Software Engineer
Parsons Government Services , National Security & Defense Division

--Sig_/mRY9=.YCENZnt=Du4.sowwQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlJn+A8ACgkQ7/fVLLY1mnjHMwCfTP4dGrrAPBPFhQZcUeL3YCbd
o5IAnR2dffPNHg8/WoVzmC35jVbJa74F
=EYTJ
-----END PGP SIGNATURE-----

--Sig_/mRY9=.YCENZnt=Du4.sowwQ--
