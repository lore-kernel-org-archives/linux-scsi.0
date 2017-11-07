From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] scsi_debugfs: fix crash in scsi_show_rq()
Date: Tue, 7 Nov 2017 23:07:48 +0800
Message-ID: <20171107150747.GA5899@ming.t460p>
References: <20171107145526.19315-1-ming.lei@redhat.com>
 <88aa2b0b-ef36-411e-a429-06da2dda50d3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933868AbdKGPID (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Nov 2017 10:08:03 -0500
Content-Disposition: inline
In-Reply-To: <88aa2b0b-ef36-411e-a429-06da2dda50d3@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@fb.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.com>

On Tue, Nov 07, 2017 at 03:04:09PM +0000, John Garry wrote:
> Hi Ming,
> 
> On 07/11/2017 14:55, Ming Lei wrote:
> > +		strcpy(buf, "unknow");
> 
> typo?

Yeah, will fix it in V2, thanks!

-- 
Ming
