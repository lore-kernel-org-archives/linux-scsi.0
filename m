From: Doug Ledford <dledford@redhat.com>
Subject: Re: Warning - running *really* short on DMA buffers while doingfiletransfers
Date: Mon, 30 Sep 2002 19:49:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020930234957.GG25340@redhat.com>
References: <Pine.BSF.4.21.0209271417260.22542-100000@beppo> <200209272123.g8RLNAi21161@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200209272123.g8RLNAi21161@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mjacob@feral.com, "Justin T. Gibbs" <gibbs@scsiguy.com>, Andrew Morton <akpm@digeo.com>, Jens Axboe <axboe@suse.de>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Sep 27, 2002 at 05:23:10PM -0400, James Bottomley wrote:
> mjacob@feral.com said:
> > Duh. There had been race conditions in the past which caused all of us
> > HBA writers to in fact start swalloing things like QFULL and
> > maintaining internal queues. 
> 
> That was true of 2.2, 2.3 (and I think early 2.4) but it isn't true of late 
> 2.4 and 2.5

Oh, it's true of current 2.4 (as of 2.4.19).  It's broken for new and old 
eh drivers both in 2.4.  Hell, it's still broken for new eh drivers in 2.5 
as well.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
