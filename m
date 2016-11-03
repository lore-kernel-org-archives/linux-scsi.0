From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 03/16] scsi: fc: Export fc_bsg_jobdone and use it in FC
 drivers
Date: Thu, 3 Nov 2016 15:04:18 -0700
Message-ID: <3ad74dab-5f10-63a5-80c2-121448b2f9d0@linux.vnet.ibm.com>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <b7afadab74451838c0b29cc857a7d47174f68c39.1476369687.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b7afadab74451838c0b29cc857a7d47174f68c39.1476369687.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, "open list:S390 ZFCP DRIVER" <linux-s390@vger.kernel.org>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Christoph Hellwig <hch@infradead.org>, "open list:FCOE SUBSYSTEM libfc, libfcoe, fcoe" <fcoe-devel@open-fcoe.org>, Steffen Maier <maier@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, James Smart <james.smart@avagotech.com>, Martin
List-Id: linux-scsi@vger.kernel.org

On 10/13/2016 08:00 AM, Johannes Thumshirn wrote:
> Export fc_bsg_jobdone so drivers can use it directly instead of doing
> the round-trip via struct fc_bsg_job::job_done() and use it in the LLDDs.
> 
> As we've converted all LLDDs over to use fc_bsg_jobdone() directly,
> we can remove the function pointer from struct fc_bsg_job as well.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

For ibmvfc parts,

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com
