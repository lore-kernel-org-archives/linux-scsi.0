From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sd: Fix a race between closing an sd device and sd I/O
Date: Tue, 26 Mar 2019 08:39:19 +0100
Message-ID: <20190326073919.GC21617@lst.de>
References: <20190325170146.184414-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190325170146.184414-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jason Yan <yanaijie@huawei.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
