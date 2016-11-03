From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 03/16] scsi: fc: Export fc_bsg_jobdone and use it in
 FC drivers
Date: Thu, 3 Nov 2016 08:17:01 -0700
Message-ID: <20161103151701.GB7404@infradead.org>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <b7afadab74451838c0b29cc857a7d47174f68c39.1476369687.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b7afadab74451838c0b29cc857a7d47174f68c39.1476369687.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dic
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 05:00:19PM +0200, Johannes Thumshirn wrote:
> Export fc_bsg_jobdone so drivers can use it directly instead of doing
> the round-trip via struct fc_bsg_job::job_done() and use it in the LLDDs.
> 
> As we've converted all LLDDs over to use fc_bsg_jobdone() directly,
> we can remove the function pointer from struct fc_bsg_job as well.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
