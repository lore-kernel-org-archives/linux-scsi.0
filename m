From: simoneau@ele.uri.edu
Subject: Re: [PATCH] kill qlogicpti inquiry sniffing
Date: Mon, 21 Nov 2005 14:21:57 -0500
Message-ID: <20051121142157.jp5jizqls04og448@webmail.ele.uri.edu>
References: <20051017120229.GA5834@lst.de> <20051112091251.GA15402@lst.de>
	<20051119184447.GA29275@lst.de>
	<20051121080951.zmygxh5miows4wk4@webmail.ele.uri.edu>
	<5460e3330511210931w5b0ff188o56feaeab66e41e22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_5w5nysjse9c8";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orca.ele.uri.edu ([131.128.51.63]:41366 "EHLO orca.ele.uri.edu")
	by vger.kernel.org with ESMTP id S1750986AbVKUTWq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 14:22:46 -0500
In-Reply-To: <5460e3330511210931w5b0ff188o56feaeab66e41e22@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Joensson <christian.joensson@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, davem@davemloft.net, tcallawa@redhat.com, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

This message is in MIME format and has been PGP signed.

--=_5w5nysjse9c8
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Quoting Christian Joensson <christian.joensson@gmail.com>:

> On 11/21/05, simoneau@ele.uri.edu <simoneau@ele.uri.edu> wrote:
>> Quoting Christoph Hellwig <hch@lst.de>:
>>
>> > On Sat, Nov 12, 2005 at 10:12:51AM +0100, Christoph Hellwig wrote:
>> >> On Mon, Oct 17, 2005 at 02:02:29PM +0200, Christoph Hellwig wrote:
>> >> > Inquiry sniffing is a really bad idea, and sneaking a patch in without
>> >> > talking to the scsi maintainers doesn't make it any better ;-)
>> >> >
>> >> > Could one of the sparc people please test the patch below to kill it?
>> >>
>> >> ping?
>> >
>> > ping^2.  Hey, there must be sparc users with this hardware that noticed
>> > the initial bug, could you please test this patch?
>> >
>>
>> I have an SBUS qpti card which had some major problem (kernel BUG()
>> during boot
>> in the qlogicpti driver) last time when I tried 2.6.14, I can test 
>> the patch.
>> SS20MP 2xSuperSPARC here, just give me a while to compile a kernel.
>
> what is the status of linux SMP kernel 2.6 and sun4m?
>
> --
> Cheers,
>
> /ChJ
>


Either I did something wrong or the 2.6+sparc32 build is completely broken...
lots of this on every module:

WARNING: /lib/modules/2.6.14.2/kernel/drivers/cdrom/cdrom.ko needs unknown
symbol div
WARNING: /lib/modules/2.6.14.2/kernel/drivers/cdrom/cdrom.ko needs unknown
symbol rem
WARNING: /lib/modules/2.6.14.2/kernel/drivers/cdrom/cdrom.ko needs unknown
symbol umul

I'm using module-init-tools 3.2_pre7, gcc 3.4.4, and binutils 2.16.1 in 
case it
matters.

--=_5w5nysjse9c8
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD4DBQBDgh5VLYBaX8VDLLURAgMTAKC6KlcUHq7vmHYa0MTO/rwF5/jtXgCXf46H
ZT4c0FkphAygnt7hBlkAYA==
=JpOz
-----END PGP SIGNATURE-----

--=_5w5nysjse9c8--

