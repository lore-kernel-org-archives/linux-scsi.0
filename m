From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add proper module ID tables to Adaptec aic7[9x]xx drivers
Date: Thu, 7 Oct 2004 21:36:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041007213612.A17286@infradead.org>
References: <linux.scsi.20040621161047.GD16453@master.mivlgu.local> <41644BD5.7030807@tls.msk.ru> <20041006202543.GA22794@wotan.suse.de> <4165862E.1040904@adaptec.com> <4165950C.509@tls.msk.ru> <41659D30.7050705@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baythorne.infradead.org ([81.187.226.107]:38921 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268088AbUJGUgU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 16:36:20 -0400
Content-Disposition: inline
In-Reply-To: <41659D30.7050705@adaptec.com>; from luben_tuikov@adaptec.com on Thu, Oct 07, 2004 at 03:46:56PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-scsi@vger.kernel.org

On Thu, Oct 07, 2004 at 03:46:56PM -0400, Luben Tuikov wrote:
> Michael Tokarev wrote:
> > Luben Tuikov wrote:
> > 
> >> Andi Kleen wrote:
> >>
> > []
> > 
> >>> Luben, can you just do a proper pci_id table please? You probably
> >>> know the requirements best.
> >>
> >>
> >> Yes, no problem. (It'd be tricky but I'll try to augment it properly.)
> > 
> > 
> > Christoph Hellwig already did that, it seems --
> > see his post to linux-scsi dated Sep-12,
> > http://marc.theaimsgroup.com/?m=109500574722283
> 
> Yes, I forgot about this one -- this is pretty much what I
> had intended to do.

The version had a few bugs unfortunately.  For various HP boards
I mixed up vendor and subvendor id, and the raid boards are completely
missing.  I tried to fix that up but got totally lost in the various ids.

If there's a completely list of AIC79XX board variants I could try again.
