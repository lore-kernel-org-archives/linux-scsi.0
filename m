From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v8 6/7] sd: Implement support for ZBC devices
Date: Wed, 19 Oct 2016 09:21:59 -0400
Message-ID: <x497f94scco.fsf@segfault.boston.devel.redhat.com>
References: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
        <1476772835-18541-7-git-send-email-damien.lemoal@wdc.com>
        <x498ttlvbks.fsf@segfault.boston.devel.redhat.com>
        <yq1y41lf9qk.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942870AbcJSOly (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Oct 2016 10:41:54 -0400
In-Reply-To: <yq1y41lf9qk.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
        message of "Tue, 18 Oct 2016 20:44:35 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>, Damien Le Moal <damien.lemoal@hgst.com>

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:
>
> Jeff,
>
> Jeff> Are power of 2 zone sizes required by the standard?  I see why
> Jeff> you've done this, but I wonder if we're artificially limiting the
> Jeff> implementation, and whether there will be valid devices on the
> Jeff> market that simply won't work with Linux because of this.
>
> Standards are deliberately written to be permissive. But Linux doesn't
> support arbitrary sector sizes either even though the spec allows it. We
> always pick a reasonably sane subset of features to implement and this
> case is no different.
>
> After some discussion we decided to rip out all the complexity that was
> required to facilitate crazy drive layouts. As a result, the code is now
> in a state where we can actually merge it. The hope is that by picking a
> specific configuration subset and widely advertising it we can influence
> the market.
>
> Also, I am not aware of anybody actually asking the drive vendors to
> support crazy zone configurations.

That's fine with me.  I didn't see any mention of this design decision
in the patch logs, though, and given that I'm not intimately involved, I
asked the question.

Thanks,
Jeff
