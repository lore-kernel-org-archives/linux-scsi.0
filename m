From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
Date: Tue, 22 Jan 2008 17:58:54 -0600
Message-ID: <1201046335.14436.92.camel@cinder.waste.org>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
	 <1201022985.3210.24.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801221813540.8693@blonde.site>
	 <1201031028.3210.61.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801222009070.16267@blonde.site>
	 <1201039931.3210.96.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801222241460.30816@blonde.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801222241460.30816@blonde.site>
Sender: linux-ide-owner@vger.kernel.org
To: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Tue, 2008-01-22 at 22:59 +0000, Hugh Dickins wrote:
> On Tue, 22 Jan 2008, James Bottomley wrote:
> > 
> > libsas looks to be OK because it specifically kmallocs a 512 byte buffer
> > which should (for off slab data) be 512 byte aligned.
> 
> I don't remember the various SLAB and SLOB and SLUB rules offhand:
> I'm not sure it's safe to rely on such alignment on all of them ....

It doesn't work that way with SLOB kmalloc (nor did it in pre-slabified
kmalloc). One shouldn't be surprised if a SLAB/SLUB debugging feature
breaks that alignment either.

-- 
Mathematics is the supreme nostalgia of our time.

