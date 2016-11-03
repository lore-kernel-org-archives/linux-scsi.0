From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 04/16] scsi: Unify interfaces of fc_bsg_jobdone and
 bsg_job_done
Date: Thu, 3 Nov 2016 08:17:33 -0700
Message-ID: <20161103151733.GC7404@infradead.org>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <2b02bb8460fa27db4fe971a2161e0cb7c2fca4df.1476369687.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2b02bb8460fa27db4fe971a2161e0cb7c2fca4df.1476369687.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dic
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 13, 2016 at 05:00:20PM +0200, Johannes Thumshirn wrote:
> Unify the interfaces of fc_bsg_jobdone and bsg_job_done. This will reduce the
> diff when moving from 'struct fc_bsg_job' to a plain 'struct bsg_job' later
> on.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Looks fine, although I would have merged it into the previous patch:

Reviewed-by: Christoph Hellwig <hch@lst.de>
