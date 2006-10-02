From: Christoph Lameter <clameter@sgi.com>
Subject: Re: GFP_DMA use in SCSI midlayer
Date: Mon, 2 Oct 2006 15:24:02 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0610021521080.16692@schroedinger.engr.sgi.com>
References: <200610012213.24123.ak@suse.de> <200610012255.49802.ak@suse.de>
 <1159800770.3460.11.camel@mulgrave.il.steeleye.com> <200610022118.46830.ak@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx1-ext.sgi.com ([192.48.179.11]:29159 "EHLO
	omx1.americas.sgi.com") by vger.kernel.org with ESMTP
	id S965479AbWJBWYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Oct 2006 18:24:10 -0400
In-Reply-To: <200610022118.46830.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org

On Mon, 2 Oct 2006, Andi Kleen wrote:

> > > GFP_DMA will also fail on a lot of platforms, so it's the same.
> > 
> > No, at the moment it succeeds on all of them (although at odd locations,
> > like on parisc GFP_DMA goes up to 4GB).
> 
> Not after Christoph's patchkit went in.

Well we can make it fail if you want to do that. Currently if you do not 
have CONFIG_ZONE_DMA set it simply ignores GFP_DMA because of the weird 
stuff in places like the SCSI layer. If you would fix it up then I could 
warn on GFP_DMA.
