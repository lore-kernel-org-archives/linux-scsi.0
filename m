From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared -
 system 	is dreadfully slow)
Date: Mon, 22 Jun 2009 18:11:00 +0100
Message-ID: <20090622181100.43a56309@lxorguk.ukuu.org.uk>
References: <20090621.141950.160759111.davem@davemloft.net>
	<200906220034.22430.bzolnier@gmail.com>
	<20090621.155756.100422570.davem@davemloft.net>
	<20090621.161343.181101055.davem@davemloft.net>
	<87f94c370906212039sa23d49fh305d8f0d58a48d1f@mail.gmail.com>
	<4A3FB956.6060401@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <4A3FB956.6060401@garzik.org>
Sender: sparclinux-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, David Miller <davem@davemloft.net>, bzolnier@gmail.com, elendil@planet.nl, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> There are a handful of IDE drivers not yet ported over to libata, all 
> !x86 drivers; maybe there's an odd ARM platform or two in there, I 
> haven't checked recently.

There are several drivers that are not supported in libata (and several
only in libata, and several that work better in one than the other for
reasons nobody can figure sometimes)

Biggest legacy hanger on is the older PowerMac boxes because both people
who planned to do the driver had the mac they were using simply die of
old age on them.

sgiioc4 is another obvious "modern machine" case. The rest are pretty
obscure (eg mac68K drivers and IDE VLB drivers most of which don't
actually work in the old IDE code even though there is code)

