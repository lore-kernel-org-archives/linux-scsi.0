From: Andrew Morton <akpm@digeo.com>
Subject: Re: Warning - running *really* short on DMA buffers while doingfile  
 transfers
Date: Fri, 27 Sep 2002 12:07:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3D94AC8B.4AB6EB09@digeo.com>
References: <200209271721.g8RHLTn05231@localhost.localdomain> <2543856224.1033153019@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

"Justin T. Gibbs" wrote:
> 
> ...
> > The evidence is here:
> >
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=103302456113997&w=1
> 
> Which unfortunately characterizes only a single symptom without breaking
> it down on a transaction by transaction basis.  We need to understand
> how many writes were queued by the OS to the drive between each read to
> know if the drive is actually allowing writes to pass reads or not.
> 

Given that I measured a two-second read latency with four tags,
that would be about 60 megabytes of write traffic after the
read was submitted.  Say, 120 requests.  That's with a tag
depth of four.

Not sure how old the disk is.  It's a 36G Fujitsu SCA-2.  Manufactured
in 2000, perhaps??
