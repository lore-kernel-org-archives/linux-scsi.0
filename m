From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] SCSI: delay run queue if device is blocked in scsi_dev_queue_ready()
Date: Mon, 04 Dec 2017 09:44:55 +0100
Message-ID: <mqdo9nenapk.fsf@linux-x5ow.site>
References: <20171202163150.1273-1-ming.lei@redhat.com>
        <mqdindmoqga.fsf@linux-x5ow.site> <20171204083440.GA10261@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751407AbdLDIo6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 03:44:58 -0500
In-Reply-To: <20171204083440.GA10261@ming.t460p> (Ming Lei's message of "Mon,
        4 Dec 2017 16:34:46 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Ming Lei <ming.lei@redhat.com> writes:


> I am happy to do that, but recently I am very busy, so it may be done
> a bit late by me.
>
> But anyone should reproduce the issue 100% with V4.15-rc kernel by just
> running the above script, not any specific hardware is required at all,
> so that means anyone can make a patch for blktest to test block/SCSI
> timeout if he/she is interested in doing that.

OK, let me see if I can spent some time on this the next days.

Byte,
        Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
