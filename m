From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi_debugfs: fix crash in scsi_show_rq()
Date: Tue, 7 Nov 2017 15:04:09 +0000
Message-ID: <88aa2b0b-ef36-411e-a429-06da2dda50d3@huawei.com>
References: <20171107145526.19315-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:9971 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965250AbdKGPFS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 10:05:18 -0500
In-Reply-To: <20171107145526.19315-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@fb.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.com>

Hi Ming,

On 07/11/2017 14:55, Ming Lei wrote:
 > +		strcpy(buf, "unknow");

typo?

Thanks,
John
