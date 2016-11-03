From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 04/16] scsi: Unify interfaces of fc_bsg_jobdone and
 bsg_job_done
Date: Thu, 3 Nov 2016 15:06:02 -0700
Message-ID: <29d1ff86-83bc-1444-b057-b0f336a60832@linux.vnet.ibm.com>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <2b02bb8460fa27db4fe971a2161e0cb7c2fca4df.1476369687.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2b02bb8460fa27db4fe971a2161e0cb7c2fca4df.1476369687.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upst>
List-Id: linux-scsi@vger.kernel.org

On 10/13/2016 08:00 AM, Johannes Thumshirn wrote:
> Unify the interfaces of fc_bsg_jobdone and bsg_job_done. This will reduce the
> diff when moving from 'struct fc_bsg_job' to a plain 'struct bsg_job' later
> on.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

For ibmvfc parts,

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
