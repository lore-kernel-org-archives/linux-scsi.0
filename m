From: Paul Wagland <paul@kungfoocoder.org>
Subject: Re: Megaraid and Linux 2.6 and dellmgr questions
Date: Tue, 6 Apr 2004 08:43:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A817F5EC-8795-11D8-BC8C-000A95CD704C@kungfoocoder.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC4F1@exa-atlanta.se.lsil.com>
Mime-Version: 1.0 (Apple Message framework v613)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-14--152630309"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out3.xs4all.nl ([194.109.24.13]:51985 "EHLO
	smtp-out3.xs4all.nl") by vger.kernel.org with ESMTP id S263649AbUDFHNl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 03:13:41 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC4F1@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI mailing list <linux-scsi@vger.kernel.org>
Cc: Atul Mukker <Atulm@lsil.com>


--Apple-Mail-14--152630309
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; format=flowed


On Apr 6, 2004, at 6:49, Mukker, Atul wrote:

> I promised a release some weeks ago but we could not make it because of
> stability issues. But it is in much better shape now and would be 
> available
> for review pretty soon.

This is good to know, and as promised to you earlier, if you would 
still like I will look at (at least) getting the initial shot at 
exporting information from the driver via sysfs.

Do you know whether or not the new driver will address the issue I 
raised below? The reason that I want to be able to do this is that I 
have managed to script the dellmgr interface (using expect) and would 
like to be able to repeatedly create and then delete logical drives so 
that I can test the effects of the various logical drive parameters.

> -----Original Message-----
> From: Paul Wagland [mailto:paul@wagland.net]
>
>> problem: When using dellmgr v 5.31 to delete a logical drive on my
>> SATA-150-6 board under linux 2.6.4, the controller seems to hang. I 
>> can
>> continue to do stuff, so long as I don't want to touch that 
>> controller.
>> As this is my only IO controller that is a little tricky :-) Has this
>> problem been seen before? Is there a known workaround?

Any help would be gratefully accepted,
Cheers,
Paul

--Apple-Mail-14--152630309
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)

iD8DBQFAclGBtch0EvEFvxURAneQAJ4xq/9CR3MOZvR8K930Vfkwa0U2GgCffAPn
bUTZu1r5wwkynEtuDwZm8mQ=
=rkZz
-----END PGP SIGNATURE-----

--Apple-Mail-14--152630309--

