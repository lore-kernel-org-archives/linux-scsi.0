From: Andreas Haumer <andreas@xss.co.at>
Subject: Re: [PATCH]  2.4.23-pre8 driver udpate for MPT Fusion (2.05.10)
Date: Fri, 24 Oct 2003 20:09:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F996AE7.5020409@xss.co.at>
References: <0E3FA95632D6D047BA649F95DAB60E57035A944F@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from camus.xss.co.at ([194.152.162.19]:48399 "EHLO camus.xss.co.at")
	by vger.kernel.org with ESMTP id S262439AbTJXSJs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2003 14:09:48 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57035A944F@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mpt_linux_developer@lsil.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

Moore, Eric Dean wrote:
> Here's a patch for 2.4.23-pre8 kernel for MPT Fusion driver, coming from LSI
> Logic.
>
[...]
>
> (8)	In a mixed device configuration (Ultra 320 and Non-Ultra
> 320 devices are present on an HBA channel), code was fixed to prevent
>  negotiating for QAS on all Ultra 320 devices on that channel.
> This keeps the Ultra 320 devices from dominating the SCSI bus,
> preventing Non-Ultra 320 IO's from executing.
>
[...]

Uh Oh...

Is this a fix for the problems I reported back in June
to LKML and to Pam Delaney?

On June, 12th, I sent a mail to Pam reporting system freezes
I had on an ASUS AP 1700-S5 server with onboard 53C1030
controller. In this mail I speculated about the possibility
of a mixed device configuration beeing the source of the problem:

[...]
Another idea: is it possible that the SCSI controller
has problems with U160 and U320 SCSI disks mixed together
on the same bus? As far as I know there shouldn't be a
problem with this combination, but who knows?

I always tested with a mix of the following SCSI disks:

IBM DDYS-T18350M (18GB U160 SCA)
IBM IC35L036UCDY10-0 (36GB U320 SCA)

I'm currently running 2.4.20 with 4 U320 disks and no
U160 disk in the how swap cage. The system is now up for
about 6 hours and no SCSI timeout occured so far (this
doesn't say anything. Sometimes it takes 24 hours before
a SCSI timeout or even a freeze occurs)
[...]

I haven't got an answer to this report, but with a
all-U320 configuration I never had system freezes since.
Does the new driver now work in a U160/U320 mixed
configuration, too?

- - andreas

- --
Andreas Haumer                     | mailto:andreas@xss.co.at
*x Software + Systeme              | http://www.xss.co.at/
Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE/mWrjxJmyeGcXPhERAowMAJ9mTHr/qLObJ/OvUodLsrILx/MnkACfTj+U
7QVE6mUMmxAEYmIfvHeDItU=
=DcTz
-----END PGP SIGNATURE-----

