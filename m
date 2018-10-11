From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Wed, 10 Oct 2018 23:36:03 -0700
Message-ID: <20181011063603.GA3456@infradead.org>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
 <yq18t354532.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq18t354532.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 10, 2018 at 09:58:25PM -0400, Martin K. Petersen wrote:
> > This is because the IPTT index must be a unique value per HBA. However,
> > if we switched to SCSI MQ, the block layer tag becomes unique per queue,
> > and not per HBA.
> 
> That doesn't sound right.

blk-mq tags are always per-host (which has actually caused problems for
ATA, which is now using its own per-device tags).
