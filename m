From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing file  transfers
Date: Fri, 27 Sep 2002 14:38:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020927143841.A17108@eng2.beaverton.ibm.com>
References: <200209271721.g8RHLTn05231@localhost.localdomain> <2628736224.1033160295@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <2628736224.1033160295@aslan.btc.adaptec.com>; from gibbs@scsiguy.com on Fri, Sep 27, 2002 at 02:58:15PM -0600
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 27, 2002 at 02:58:15PM -0600, Justin T. Gibbs wrote:
> >> Hooks for sending ordered tags have been in the aic7xxx driver, at
> >> least in FreeBSD's version, since '97.  As soon as the Linux cmd
> >> blocks have such information it will be trivial to have the aic7xxx
> >> driver issue the appropriate tag types.
> > 
> > They already do in 2.5, see scsi_populate_tag_msg() in scsi.h.  This
> > assumes  you're using the generic tag queueing, which the aic7xxx
> > doesn't, but you  could easily key the tag type off REQ_BARRIER.
> 
> If anyone wants to play with the updated aic7xxx and aic79xx drivers
> (new port to 2.5, plus it honors the otag stuff), you can pick it up
> from here:
> 
> 
> http://people.FreeBSD.org/~gibbs/linux/linux-2.5-aic79xxx.tar.gz
> 
> --
> Justin

Any 2.5 patch for the above? Or aic7xxx/Config.in and
aic7xxx/Makefile for 2.5?

Thanks.

-- Patrick Mansfield
