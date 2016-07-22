From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Fri, 22 Jul 2016 16:35:45 -0400
Message-ID: <yq14m7hbece.fsf@sermon.lab.mkp.net>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
	<1468934439-93579-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1468934439-93579-2-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Tue, 19 Jul 2016 15:20:34 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> The queue limits already have a 'chunk_sectors' setting, so we
Hannes> should be presenting it via sysfs.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
