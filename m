From: Christian Iversen <chrivers@iversen-net.dk>
Subject: Re: [ANNOUNCE 0/7] Open-iSCSI/Linux-iSCSI-5 High-Performance Initiator
Date: Thu, 2 Jun 2005 00:45:58 +0200
Message-ID: <200506020046.02295.chrivers@iversen-net.dk>
References: <429E15CD.2090202@yahoo.com> <200506011654.11362.pmcfarland@downeast.net> <429E23E3.8000606@yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1177228.RHR7Cshgkd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from port741.ds1-noe.adsl.cybercity.dk ([212.242.204.118]:19028 "EHLO
	boreas.iversen-net.dk") by vger.kernel.org with ESMTP
	id S261349AbVFAWqK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2005 18:46:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by boreas.iversen-net.dk (Postfix) with ESMTP id 05CC01C3F75
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2005 00:46:06 +0200 (CEST)
Received: from boreas.iversen-net.dk ([127.0.0.1])
	by localhost (boreas.iversen-net.dk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 13463-02 for <linux-scsi@vger.kernel.org>;
	Thu, 2 Jun 2005 00:46:02 +0200 (CEST)
Received: from zephyr.iversen-net.dk (zephyr.iversen-net.dk [10.0.0.2])
	by boreas.iversen-net.dk (Postfix) with ESMTP
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2005 00:46:02 +0200 (CEST)
In-Reply-To: <429E23E3.8000606@yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

--nextPart1177228.RHR7Cshgkd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 01 June 2005 23:08, Alex Aizman wrote:
> Patrick McFarland wrote:
> > On Wednesday 01 June 2005 04:08 pm, Alex Aizman wrote:
> >> This is open-iscsi/linux-iscsi-5 Initiator. This submission is ready f=
or
> >> inclusion into mainline kernel.
> >
> > Awesome! So is this complete enough so I can, say, play DVDs from one b=
ox
> > using an ATAPI DVD drive in another box?
>
> Yep, that's what iSCSI is for, in part. You'll need iSCSI target to conne=
ct
> to the SCSI backend, e.g. http://iscsitarget.sourceforge.net/

This is really, really good work. Please keep it up :-)

I'm very much looking forward to comparing this to DVD-over-NBD, which work=
s=20
fine, except when you need to change the disc. The NBD server locks the dri=
ve=20
when it's running, and you need to restart both client and server after a=20
disc change.

Briefly, what are the security features available? I assume I can do simple=
=20
things like only allow access to an IP range (can I?), but what about more=
=20
complex things like encryption?

=2D-=20
Regards,
Christian Iversen

--nextPart1177228.RHR7Cshgkd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBCnjqqx+vwx6XMZWwRApK+AJ98OpWkIH5kuq1ELEqsXRnD+EECGwCfY+Vc
oew7JELvcw2s4Xp4QwwuVQU=
=NNnM
-----END PGP SIGNATURE-----

--nextPart1177228.RHR7Cshgkd--
