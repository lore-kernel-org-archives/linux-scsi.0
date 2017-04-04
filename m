From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC PATCH 0/2] block,scsi: support host-wide tagset
Date: Tue, 4 Apr 2017 23:59:58 +0800
Message-ID: <CACVXFVPyWL8XyFKC9uT7r4q+QT1+_RvnvJnOskCO3aSnUEVY1w@mail.gmail.com>
References: <1491307665-47656-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1491307665-47656-1-git-send-email-hare@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 4, 2017 at 8:07 PM, Hannes Reinecke <hare@suse.de> wrote:
> Hi all,
>
> as discussed recently most existing HBAs have a host-wide tagset which
> does not map easily onto the per-queue tagset model of block mq.
> This patchset implements a flag BLK_MQ_F_GLOBAL_TAGS for block-mq, which
> enables the use of a shared tagset for all hardware queues.
> The second patch adds a flag 'host_tagset' to the SCSI host template,
> which allows drivers to enable the use of the global tagset.
>
> This patchset probably has some performance implications as
> there is a quite high probability of cache-bouncing when allocating
> tags. Also I'm not quite sure if the implemented tagset sharing
> is the correct way to handle things.
> So this can be considered an RFC.
>
> As usual, comments and reviews are welcome.

Just be curious, why is multi hard queue used for this case? Are there
some real cases in SCSI?


Thanks,
Ming Lei
