From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] scsi: remove Scsi_Cmnd typedef
Date: Wed, 13 Jun 2018 04:57:19 -0700
Message-ID: <20180613115719.GA12438@infradead.org>
References: <20180613075349.7509-1-jthumshirn@suse.de>
 <20180613075349.7509-2-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613075349.7509-2-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 13, 2018 at 09:53:47AM +0200, Johannes Thumshirn wrote:
> This will make subsequent refactoring easier to handle.
> 
> Note: this patch is nowhere checkpatch clean.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

Thanks, we should have done this long time ago:

Reviewed-by: Christoph Hellwig <hch@lst.de>
