From: Paul Wagland <paul@wagland.net>
Subject: Re: [PATCH] fix for missing proc dir in megaraid driver.
Date: Wed, 18 Feb 2004 08:47:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B9FA5EC5-61E6-11D8-B07A-000A95CD704C@wagland.net>
References: <1077058085.1897.4.camel@morsel.kungfoocoder.org> <20040217231541.GG11824@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0 (Apple Message framework v612)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-26--987960"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out6.xs4all.nl ([194.109.24.7]:7440 "EHLO
	smtp-out6.xs4all.nl") by vger.kernel.org with ESMTP id S263793AbUBRHrv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 02:47:51 -0500
In-Reply-To: <20040217231541.GG11824@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>


--Apple-Mail-26--987960
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; format=flowed


On Feb 18, 2004, at 0:15, Matthew Wilcox wrote:

> On Tue, Feb 17, 2004 at 11:48:06PM +0100, Paul Wagland wrote:
>> This applies against 2.6.2. and resolves the problem of the missing
>> /proc/megaraid/* entries. The problem was that the megaraid directory
>> was getting created after it was used. Sometime in the next few days I
>> will also send through the work I have done to convert to sysfs.
>>
>
> Actually, all the CONFIG_PROC_FS ifdefs can go away.  They're properly
> stubbed in include/linux/proc_fs.h.

OK, I can resubmit with those #ifdefs in megaraid_init removed, though 
this does raise the size of the module in that case by a small amount, 
and also means that even though the kernel is configured as being a 
non-procfs kernel, the megaraid module will still complain that it 
cannot "create megaraid root". Hmm. Looking at this, this error message 
is not overly intuitive anyway :-), but when procfs is not even 
configured this could easily be mistaken for something quite serious.

If you would like a re-submit with the CONFIG_PROC_FS removed, then 
just let me know.

Cheers,
Paul

--Apple-Mail-26--987960
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (Darwin)

iD8DBQFAMxibtch0EvEFvxURApO1AJ9ntOpB0ktRO2O4BFtVjZdDNo1dAgCfdzUL
T+mjPzwrHQaysMu0Dd3CR38=
=q/AI
-----END PGP SIGNATURE-----

--Apple-Mail-26--987960--

