From: simoneau@ele.uri.edu
Subject: Re: [PATCH] kill qlogicpti inquiry sniffing
Date: Mon, 21 Nov 2005 08:09:51 -0500
Message-ID: <20051121080951.zmygxh5miows4wk4@webmail.ele.uri.edu>
References: <20051017120229.GA5834@lst.de> <20051112091251.GA15402@lst.de>
	<20051119184447.GA29275@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_67y324s82z8c";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:16622 "EHLO orca.ele.uri.edu")
	by vger.kernel.org with ESMTP id S932303AbVKUNK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 08:10:56 -0500
In-Reply-To: <20051119184447.GA29275@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, davem@davemloft.net, tcallawa@redhat.com, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

This message is in MIME format and has been PGP signed.

--=_67y324s82z8c
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Quoting Christoph Hellwig <hch@lst.de>:

> On Sat, Nov 12, 2005 at 10:12:51AM +0100, Christoph Hellwig wrote:
>> On Mon, Oct 17, 2005 at 02:02:29PM +0200, Christoph Hellwig wrote:
>> > Inquiry sniffing is a really bad idea, and sneaking a patch in without
>> > talking to the scsi maintainers doesn't make it any better ;-)
>> >
>> > Could one of the sparc people please test the patch below to kill it?
>>
>> ping?
>
> ping^2.  Hey, there must be sparc users with this hardware that noticed
> the initial bug, could you please test this patch?
>

I have an SBUS qpti card which had some major problem (kernel BUG() 
during boot
in the qlogicpti driver) last time when I tried 2.6.14, I can test the patch.
SS20MP 2xSuperSPARC here, just give me a while to compile a kernel.

--=_67y324s82z8c
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBDgccfLYBaX8VDLLURAte9AJ9bDvPXbWrJoTsOud2kNeFyIZ2mLwCdFUkS
zzP7KhzID9vpdJTc9LFIMLo=
=juFv
-----END PGP SIGNATURE-----

--=_67y324s82z8c--

