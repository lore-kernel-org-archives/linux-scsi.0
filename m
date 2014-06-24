From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: sd_setup_discard_cmnd: BUG: unable to handle kernel NULL pointer
 dereference at (null)
Date: Tue, 24 Jun 2014 13:53:24 +0200
Message-ID: <20140624115324.GB17123@soda.linbit>
References: <53A28B21.7070500@profihost.ag>
 <yq1ionwjn15.fsf@sermon.lab.mkp.net>
 <20140620155321.GA24389@soda.linbit>
 <yq1wqcbil0c.fsf@sermon.lab.mkp.net>
 <20140620182956.GB24389@soda.linbit>
 <yq1vbrrh0yo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1vbrrh0yo.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, konrad.wilk@oracle.com, elder@linaro.org, Josh Durgin <josh.durgin@inktank.com>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 23, 2014 at 03:37:03PM -0400, Martin K. Petersen wrote:
> >>>>> "Lars" == Lars Ellenberg <lars.ellenberg@linbit.com> writes:
> 
> Lars,
> 
> Thanks for fixing this. 
> 
> I'd still like to see you use the lib call instead like you do for
> zeroout. I have some patches in the pipeline for multi-range discard
> support and things are going to break for drbd if you manually roll
> bios.

Okay, thanks for the heads up.
I think we just did this so we would not
have to use a synchronous interface there.

We are receiving (from network) and submitting (to lower level IO stack)
in the same context and would like the submit to be async.

Do you intend to provide an asynchronous interface?

	Lars

