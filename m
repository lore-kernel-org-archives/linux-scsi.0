From: Mukul Kotwani <mkotwani@yahoo.com>
Subject: Re: Max IO size
Date: Thu, 1 Aug 2002 16:54:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020801235432.14372.qmail@web14005.mail.yahoo.com>
References: <20020801084547.GA12715@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020801084547.GA12715@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org


Thanks for the reply!

All my values are set high. The sg_tablesize value is
set to 249, max_sectors set to 1024, and I dont think
there is any other value which affects IO size as
such. I didnt see anything called max segment size/max
size in the host template. Any other things I am
missing?

Thanks!
Mukul

--- Jens Axboe <axboe@suse.de> wrote:
> On Wed, Jul 31 2002, Mukul Kotwani wrote:
> > Hello!
> > Couple of other questions..forgot to ask in the
> > previous email!
> > 
> > 1) When we do 512 byte sequential reads, the mid
> > level( or someone else) seems to be combining the
> > requests and sending them down as one big 60k+
> > request. Can this combining of requests be
> disabled
> > somehow?
> 
> not the mid layer, it's the block layer doing that
> for you. you can
> limit the size of each i/o with the max_sectors part
> of the scsi host
> template.
> 
> > 2) If we do 512k IOs, the mid layer seems to be
> > breaking it up into 64 k chunks. The Scatter
> gather
> > size is set to 240, so there is no reason for it
> to
> > break it up. Is there something I am missing? Or
> is
> > there a tunable I can set to increase the IO size
> sent
> > down to the low level driver?
> 
> again, the mid layer does not do any combining or
> breaking up of i/o
> requests. the block layer will assemble requests
> according to the rules
> set for it, these rules you control with the host
> template settings.
> these are things like max size, max segments, max
> segment size, etc.
> 
> > 3) What exactly does the max_sectors in the host
> > structure do?
> 
> see above :-)
> 
> -- 
> Jens Axboe
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html


__________________________________________________
Do You Yahoo!?
Yahoo! Health - Feel better, live better
http://health.yahoo.com
