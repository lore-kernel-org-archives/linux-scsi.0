From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 00/10] Re-implement am53c974 driver
Date: Fri, 21 Nov 2014 11:47:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1411211142380.5204@axis700.grange>
References: <1416562077-105715-1-git-send-email-hare@suse.de>
 <20141121102639.GA31016@lst.de> <546F14FF.3080509@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56298 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaKUKrj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 05:47:39 -0500
In-Reply-To: <546F14FF.3080509@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, davem@davemloft.net

Hi,

On Fri, 21 Nov 2014, Hannes Reinecke wrote:

> On 11/21/2014 11:26 AM, Christoph Hellwig wrote:
> > On Fri, Nov 21, 2014 at 10:27:47AM +0100, Hannes Reinecke wrote:
> >> Hi all,
> >>
> >> having found some issues with the current tmscsim driver
> >> I looked at the code and found is really awkward to clean
> >> up.
> >> Seeing that the am53c974 chip is actually based on the
> >> 'ESP' chip design I've re-implemented it based on the
> >> common esp_scsi routines. This new driver
> >> (cunningly named 'am53c974') provides all features
> >> found on the tmscsim driver, with the goal of obsoleting
> >> the old tmscsim driver.
> >> Tested with Tekram DC390 and qemu esp-scsi.
> > 
> > This looks very nice!
> > 
> > Three high level comments:
> > 
> >  - please Cc Dave for changes to esp_scsi
> That's what I thought, too, but 'get_maintainers.pl' doesn't
> know about him. Maybe we should fix this up ...
> 
> >  - please Cc Guennadi as the tmscsim maintainer
> >  - this probably should deprecated and/or remove the tmscsim driver
> > 
> That was the general idea. I just thought to be conservative and
> add a new driver. But yeah, the idea is to sent another patch
> to remove tmscsim altogether.

Sure, the driver is rather old and... well... its style is somewhat 
foreign to the modern Linux kernel coding style :) I actually also 
thought, that the hardware is really legacy and hardly anyone is still 
using it, so the tmscsim driver was in a bug-fix only mode, but if you 
want to replace it with a better written one - certainly go for it! I've 
hardly had any work with this my maintainer task in the last few years, 
except for a recent SCSI Tag rehash, but that was committed before I had 
enough time to sufficiently understand them :) And I'm not using that 
hardware actively any more these days... So, I'd have nothing against 
removal of tmscsim and, respectively, from its entry in MAINTAINERS :)

Thanks
Guennadi
