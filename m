From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Sparc ESP problem with blk-mq
Date: Sun, 19 Oct 2014 07:10:12 -0700
Message-ID: <20141019141012.GA24343@infradead.org>
References: <20141015.165324.1768019967735260346.davem@davemloft.net>
 <alpine.LRH.2.11.1410160942150.13273@adalberg.ut.ee>
 <20141017.155612.266274322805506383.davem@davemloft.net>
 <20141018.133132.1505060820853861420.davem@davemloft.net>
 <20141018175703.GA16988@infradead.org>
 <alpine.LRH.2.11.1410191509030.32417@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1410191509030.32417@adalberg.ut.ee>
Sender: sparclinux-owner@vger.kernel.org
To: mroos@linux.ee
Cc: David Miller <davem@davemloft.net>, axboe@kernel.dk, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 19, 2014 at 03:10:00PM +0300, mroos@linux.ee wrote:
> > > Christoph, I don't see how the new tagging code with blk-mq can
> > > be providing compatible behavior for existing SCSI drivers.
> > 
> > It doesn't, and that's my fault.
> > 
> > Please try the patch below:
> 
> Seems to have worked - the machine booted up with scsi blk mq enabled, I 
> just can not log in since I forgot to apply the fault code ptach and mys 
> ssh is killed.

Thanks for the testing.  I will split, document and submit the patch ASAP.

