From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Fix a race between closing an sd device and sd I/O
Date: Wed, 27 Mar 2019 21:18:34 -0400
Message-ID: <yq1o95vvlsl.fsf@oracle.com>
References: <20190325170146.184414-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190325170146.184414-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 25 Mar 2019 10:01:46 -0700")
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jason Yan <yanaijie@huawei.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Bart,

> The scsi_end_request() function calls scsi_cmd_to_driver() indirectly
> and hence needs the disk->private_data pointer. Avoid that that
> pointer is cleared before all affected I/O requests have
> finished. This patch avoids that the following crash occurs:

Applied to 5.1/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
