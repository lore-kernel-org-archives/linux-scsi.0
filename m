From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 1/7] =?utf-8?B?0ZVk?=
        =?utf-8?Q?=3A?= split sd_setup_discard_cmnd
Date: Thu, 30 Mar 2017 10:49:43 +0200
Message-ID: <20170330084943.GA12015@lst.de>
References: <20170320204319.12628-1-hch@lst.de> <20170320204319.12628-2-hch@lst.de> <1490653474.7897.13.camel@sandisk.com> <20170328140509.GA27578@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170328140509.GA27578@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 28, 2017 at 08:05:09AM -0600, axboe@kernel.dk wrote:
> > Although I know this is an issue in the existing code and not something
> > introduced by you: please consider using logical_to_sectors() instead of
> > open-coding this function. Otherwise this patch looks fine to me.
> 
> The downside of doing that is that we still call ilog2() twice, which
> sucks. Would be faster to cache ilog2(sector_size) and use that in the
> shift calculation.

I suspect that gcc is smart enough to optimize it away.  That beeing said
while this looks like a nice cleanup this patch is just supposed to move
code, so I'd rather not add the change here and leave it for a separate
submission.
