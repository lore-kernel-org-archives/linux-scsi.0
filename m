From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] ipr: don't doublefree pages from scatterlist
Date: Mon, 6 Feb 2006 23:13:17 +0100
Message-ID: <200602062313.18041.ak@suse.de>
References: <Pine.LNX.4.61.0602040004020.5406@goblin.wat.veritas.com> <200602062211.29993.ak@suse.de> <Pine.LNX.4.61.0602062154430.3652@goblin.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932396AbWBFW0n@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0602062154430.3652@goblin.wat.veritas.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Ryan Richter <ryan@tau.solarneutrino.net>, Brian King <brking@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, James.Bottomley@steeleye.com, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 06 February 2006 23:11, Hugh Dickins wrote:
> On Mon, 6 Feb 2006, Andi Kleen wrote:
> > On Monday 06 February 2006 17:45, Hugh Dickins wrote:
> > > 
> > > But all this presupposes that someone is suddenly going to change the
> > > x86_64 gart_map_sg (and subfunctions), or else force its iommu=nomerge:
> > > that won't be me.
> > 
> > Ok i changed it to conform to the gospel. I gave it some basic pounding LTP/dd IO with 
> > and without IOMMU force, but it's not that well tested. More testing welcome.
> 
> Great, thanks Andi.  One small correction to the comment...
> 
> > Don't touch the non DMA members in the sg list in dma_map_sg in the IOMMU
> > 
> > Some drivers (in particular ipr) ran into problems because they
> 
> No, the problem hasn't knowingly been sighted on ipr,

Ok. I was wondering anyways why people should use ipr on x86-64.

> it was the 
> st driver that Ryan's been seeing it with - ipr just came from
> my looking around for like instances.

I will fix the comment. Thanks.

-Andi
