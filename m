From: Robert Story <rstory@tislabs.com>
Subject: Re: kernel cant access SATA adapter device
Date: Thu, 17 Oct 2013 13:02:49 -0400
Message-ID: <20131017130249.4a49bd46@kvm171.vb.futz.org>
References: <20131016154651.7280ce92@kvm171.vb.futz.org>
	<20131017155924.GA31331@taco-ThinkPad-X220>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ShRnFPdRdgmOTSP55jT65zc"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from walnut.tislabs.com ([192.94.214.200]:45954 "EHLO
	walnut.tislabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928Ab3JQRC4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2013 13:02:56 -0400
In-Reply-To: <20131017155924.GA31331@taco-ThinkPad-X220>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: taco <tacoee@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--Sig_/ShRnFPdRdgmOTSP55jT65zc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Oct 2013 23:59:24 +0800 taco wrote:
T> What is the version of mptsas driver?

modinfo mptsas reports verion 3.04.20. Kernel is 2.6.32-358 (RHEL 6.3).

T> It seems that the mptsas's driver can't recognize the the type of SD
T> card and treat it as normal hard disk drive.

Ok. So how would I figure out what mptsas is looking at to determine how to
treat it? Or is there some kernel param I can pass that says sda=3Dsdcard or
soemthing?


Robert

--
Senior Software Engineer
Parsons Government Services , National Security & Defense Division

--Sig_/ShRnFPdRdgmOTSP55jT65zc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlJgGD8ACgkQ7/fVLLY1mnjOAQCggqN6RReqpyK1LMPsuiMCiFxs
cRsAnApaW44DiBwk2Gzq3pkh+jaEjNK2
=17W2
-----END PGP SIGNATURE-----

--Sig_/ShRnFPdRdgmOTSP55jT65zc--
