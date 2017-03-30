From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 23/23] block: remove the discard_zeroes_data flag
Date: Thu, 30 Mar 2017 11:06:55 +0200
Message-ID: <20170330090655.GF12015@lst.de>
References: <20170323143341.31549-1-hch@lst.de> <20170323143341.31549-24-hch@lst.de> <1490720411.2573.11.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490720411.2573.11.camel@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "agk@redhat.com" <agk@redhat.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "shli@kernel.org" <shli@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 28, 2017 at 05:00:48PM +0000, Bart Van Assche wrote:
> 
> It seems to me like the documentation in Documentation/ABI/testing/sysfs-block
> and the above code are not in sync. I think the above code will cause reading
> from the discard_zeroes_data attribute to return an empty string ("") instead
> of "0\n".

Thanks, fine with me.

> 
> BTW, my personal preference is to remove this attribute entirely because keeping
> it will cause confusion, no matter how well we document the behavior of this
> attribute.

Jens, any opinion?  I'd like to remove it too, but I fear it might
break things.  We could deprecate it first with a warning when read
and then remove it a few releases down the road.
