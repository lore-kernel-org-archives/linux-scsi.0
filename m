From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/2] scsi-mq: Only show the CDB if available
Date: Wed, 6 Dec 2017 00:38:25 +0800
Message-ID: <20171205163824.GB23788@ming.t460p>
References: <20171205003809.1705-1-bart.vanassche@wdc.com>
 <20171205003809.1705-2-bart.vanassche@wdc.com>
 <20171205011536.GC8365@ming.t460p>
 <1512439190.2739.0.camel@wdc.com>
 <20171205050008.GA9989@ming.t460p>
 <1512490952.2660.18.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512490952.2660.18.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 05, 2017 at 04:22:33PM +0000, Bart Van Assche wrote:
> On Tue, 2017-12-05 at 13:00 +0800, Ming Lei wrote:
> > No, do not mix two different things in one patch, especially the fix part
> > need to be backported to stable.
> > 
> > The fix part should aim at V4.15, and the other part can be a V4.16
> > stuff.
> 
> Does this mean that you do not plan to post a v5 of your patch and that you
> want me to rework this patch series? I can do that.

I believe V4 has been OK for merge, actually the only concern from James
is that 'set the cmnd to NULL *before* calling free so we narrow the race
window.', but that isn't required as I explained, even though you don't do
that in this patch too.

	https://marc.info/?t=151030464300003&r=1&w=2

I will work on V5 if Martin/James thinks it is needed.

-- 
Ming
