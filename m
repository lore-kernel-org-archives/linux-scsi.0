From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH V2 2/8] blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
Date: Wed, 7 Feb 2018 08:09:21 -0800
Message-ID: <7c7062b9-5333-6530-8561-35936a51240e@wdc.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-3-ming.lei@redhat.com>
 <398c755a-ada6-1e60-9562-51b69476e55d@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:29450 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754656AbeBGQJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2018 11:09:22 -0500
In-Reply-To: <398c755a-ada6-1e60-9562-51b69476e55d@kernel.dk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

On 02/06/18 15:18, Jens Axboe wrote:
> GLOBAL implies that it's, strangely enough, global. That isn't really the
> case. Why not call this BLK_MQ_F_HOST_TAGS or something like that? I'd
> welcome better names, but global doesn't seem to be a great choice.
> 
> BLK_MQ_F_SET_TAGS?

I like the name BLK_MQ_F_HOST_TAGS because it refers how these tags will 
be used by SCSI LLDs, namely as a host-wide tag set.

Thanks,

Bart.
