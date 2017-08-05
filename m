From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 04/14] blk-mq-sched: improve dispatching from sw queue
Date: Sat, 5 Aug 2017 01:40:49 -0700
Message-ID: <20170805084048.GA6643@infradead.org>
References: <20170731165111.11536-1-ming.lei@redhat.com>
 <20170731165111.11536-6-ming.lei@redhat.com>
 <1501544074.2466.29.camel@wdc.com>
 <20170801101718.GB31452@ming.t460p>
 <20170801105013.GD31452@ming.t460p>
 <1501600301.2475.1.camel@wdc.com>
 <20170802033135.GB7267@ming.t460p>
 <1501724126.30887.3.camel@wdc.com>
 <20170803031344.GA8327@ming.t460p>
 <1501781583.2922.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1501781583.2922.12.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "loberman@redhat.com" <loberman@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 03, 2017 at 05:33:13PM +0000, Bart Van Assche wrote:
> Are you aware that the SCSI core already keeps track of the number of busy requests
> per LUN? See also the device_busy member of struct scsi_device. How about giving the
> block layer core access in some way to that counter?

I'd love ot move it to blk-mq in a scalable way eventually, as
we'll run into the same problems with NVMe systems with multiple
namespaces.
