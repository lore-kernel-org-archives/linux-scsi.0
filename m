From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 10/16] scsi: change FC drivers to use 'struct bsg_job'
Date: Thu, 3 Nov 2016 15:10:09 -0700
Message-ID: <664a8549-f7d8-f648-0cdc-b54ab1299f13@linux.vnet.ibm.com>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <3704bc7c3933d97357e1c21b84da990b15321c6d.1476369687.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3704bc7c3933d97357e1c21b84da990b15321c6d.1476369687.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, "open list:S390 ZFCP DRIVER" <linux-s390@vger.kernel.org>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Christoph Hellwig <hch@infradead.org>, "open list:FCOE SUBSYSTEM libfc, libfcoe, fcoe" <fcoe-devel@open-fcoe.org>, Steffen Maier <maier@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, James Smart <james.smart@avagotech.com>, Martin
List-Id: linux-scsi@vger.kernel.org

On 10/13/2016 08:00 AM, Johannes Thumshirn wrote:
> Change FC drivers to use 'struct bsg_job' from bsg-lib.h instead of 'struct
> fc_bsg_job' from scsi_transport_fc.h and remove 'struct fc_bsg_job'.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

For ibmvfc parts,

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
