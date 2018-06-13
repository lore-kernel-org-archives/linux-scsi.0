From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/3] scsi: check for equality of result byte values
Date: Wed, 13 Jun 2018 04:58:08 -0700
Message-ID: <20180613115808.GB12438@infradead.org>
References: <20180613075349.7509-1-jthumshirn@suse.de>
 <20180613075349.7509-3-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180613075349.7509-3-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 13, 2018 at 09:53:48AM +0200, Johannes Thumshirn wrote:
> When evaluating a SCSI command's result using the field access macros,
> check for equality of the fields and not if a specific bit is set.
> 
> This is a preparation patch, for reworking the results field in the
> SCSI command.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
