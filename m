From: Mukul Kotwani <mkotwani@yahoo.com>
Subject: Re: Max IO size
Date: Thu, 1 Aug 2002 23:55:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802065548.87405.qmail@web14006.mail.yahoo.com>
References: <20020802064403.GG1512@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020802064403.GG1512@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Hello!
Thanks again!

If that is the case, then with my settings, is there
any other reason 512k requests are being broken down
into multiple 64k ones? 

Thanks!
Mukul

--- Jens Axboe <axboe@suse.de> wrote:
> On Thu, Aug 01 2002, Mukul Kotwani wrote:
> > 
> > Thanks for the reply!
> > 
> > All my values are set high. The sg_tablesize value
> is
> > set to 249, max_sectors set to 1024, and I dont
> think
> > there is any other value which affects IO size as
> > such. I didnt see anything called max segment
> size/max
> > size in the host template. Any other things I am
> > missing?
> 
> The max segment size is a property of the queue
> associated with the SCSI
> devices, it's in fact not directly controllable by
> the low level driver
> in the 2.4 kernels. What you can set in this regard
> is 'use_clustering'.
> With that set, the mid layer will attempt to merge
> contigious pages into
> the same scatter gather segment. This usually only
> provides a benefit
> with 1kb transfers (since they will typically be
> submitted in multiples
> anyway from the same page, thus it's easy to cluster
> them), with eg 4kb
> transfer sizes the amount of clustering that will
> happen is neglible.
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
