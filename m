From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Removing BROKEN scsi drivers
Date: Wed, 05 Oct 2005 10:03:09 -0400
Message-ID: <1128520989.4854.6.camel@mulgrave>
References: <200510051314.33411.ak@suse.de>
	 <20051005113108.GA19437@parisc-linux.org>
	 <20051005113925.GA11202@infradead.org> <20051005123220.GB6490@levanta.com>
	 <1128519034.5063.10.camel@laptop-lcs.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23181 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932605AbVJEODW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 10:03:22 -0400
In-Reply-To: <1128519034.5063.10.camel@laptop-lcs.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Richard Hirst <rhirst@levanta.com>, linux-m68k@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andi Kleen <ak@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>

On Wed, 2005-10-05 at 15:30 +0200, Kars de Jong wrote:
> I have at least the 53c7xx driver and the MVME16X driver working, the
> Amiga and BVME stuff is untested (but does compile).
> 
> I patched the 53c7xx core to get it to work again, but the patch is ugly
> and uses some mid level SCSI driver internals, which it shouldn't. It's
> currently only present in the m68k CVS repository.
> 
> Are you sure it's that easy to use the new 53c700 core? These boards all
> have 53c710 chips, and are quite some changes in the 53c7xx driver
> compared to the 53c8xx driver it originated from.

The 53c700 driver is a bit misnamed, it also has a 710 mode which is set
by a flag.  It's actually in common use driving three different
chipsets:

53c700: parisc 715 machines
53c700-66: Voyager systems
53c710: Voyager and parisc 712 systems

For the 53c720, we're using the ncr53c8xx driver on both voyager and
parisc.

James


