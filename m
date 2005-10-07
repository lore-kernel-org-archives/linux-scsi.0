From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Fri, 07 Oct 2005 15:53:52 +0200
Message-ID: <1128693232.5041.7.camel@laptop-lcs.localdomain>
References: <200510051314.33411.ak@suse.de>
 <20051005113108.GA19437@parisc-linux.org>
 <20051005113925.GA11202@infradead.org> <20051005123220.GB6490@levanta.com>
 <1128519034.5063.10.camel@laptop-lcs.localdomain>
 <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
 <20051007134232.GA6490@levanta.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp16.wxs.nl ([195.121.6.39]:47793 "EHLO smtp16.wxs.nl")
	by vger.kernel.org with ESMTP id S932634AbVJGNx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2005 09:53:57 -0400
In-reply-to: <20051007134232.GA6490@levanta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Hirst <rhirst@levanta.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On vr, 2005-10-07 at 14:42 +0100, Richard Hirst wrote:
> On Fri, Oct 07, 2005 at 10:27:09AM +0200, Geert Uytterhoeven wrote:
> > Indeed:
> > 
> > http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-2.6.x-merging/POSTPONED/520-53c7xx.diff
> > 
> > It was rejected upstream because patches for the 53c7xx driver are no longer
> > accepted. we should use the 53c700 core instead.
> 
> Yep; I'll find time later this month to look at switching to use 53c700.

I already did that, including the modifications needed to use the iomap
interface on m68k. I'll hopefully get around to testing it on an MVME167
this weekend.


Kind regards,

Kars.


