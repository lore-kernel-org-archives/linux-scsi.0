From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Tue, 15 Nov 2005 09:51:52 +0000
Message-ID: <20051115095152.GA23470@infradead.org>
References: <200510051314.33411.ak@suse.de> <20051005113108.GA19437@parisc-linux.org> <20051005113925.GA11202@infradead.org> <20051005123220.GB6490@levanta.com> <1128519034.5063.10.camel@laptop-lcs.localdomain> <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be> <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41122 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751413AbVKOJv7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2005 04:51:59 -0500
Content-Disposition: inline
In-Reply-To: <1128693232.5041.7.camel@laptop-lcs.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Richard Hirst <rhirst@levanta.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On Fri, Oct 07, 2005 at 03:53:52PM +0200, Kars de Jong wrote:
> > > It was rejected upstream because patches for the 53c7xx driver are no longer
> > > accepted. we should use the 53c700 core instead.
> > 
> > Yep; I'll find time later this month to look at switching to use 53c700.
> 
> I already did that, including the modifications needed to use the iomap
> interface on m68k. I'll hopefully get around to testing it on an MVME167
> this weekend.

Did you make any progress on this? 

