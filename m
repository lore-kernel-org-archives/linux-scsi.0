From: Greg KH <greg@kroah.com>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] scsi-mq prototype discussion
Date: Thu, 11 Jul 2013 18:02:23 -0700
Message-ID: <20130712010223.GA15673@kroah.com>
References: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org, Jens Axboe <axboe@kernel.dk>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, kmo@daterainc.com, target-devel <target-devel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 11, 2013 at 05:23:32PM -0700, Nicholas A. Bellinger wrote:
> Drilling down the work items ahead of a real mainline push is high on
> priority list for discussion.
> 
> The parties to be included in such a discussion are:
> 
>   - Jens Axboe (blk-mq author)
>   - James Bottomley (scsi maintainer)
>   - Christoph Hellwig (scsi)
>   - Martin Petersen (scsi)
>   - Tejun Heo (block + libata)
>   - Hannes Reinecke (scsi error recovery)
>   - Kent Overstreet (block, per-cpu ida)
>   - Stephen Cameron (scsi-over-pcie driver)
>   - Andrew Vasquez (qla2xxx LLD)
>   - James Smart (lpfc LLD)

Isn't this something that should have been discussed at the storage
mini-summit a few months ago?  It seems very specific to one subsystem
to be a kernel summit topic, don't you think?

thanks,

greg k-h
