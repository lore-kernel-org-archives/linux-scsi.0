From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 06/16] scsi: fc: provide fc_bsg_to_rport() helper
Date: Thu, 3 Nov 2016 15:08:45 -0700
Message-ID: <eeef81eb-2ffe-6d13-f0a4-c2deb7553eb2@linux.vnet.ibm.com>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <9b2273fd57def066d9c8b5b45a2ee43752a67cc9.1476369687.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9b2273fd57def066d9c8b5b45a2ee43752a67cc9.1476369687.git.jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "open list:S390 ZFCP DRIVER" <linux-s390@vger.kernel.org>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, "open list:FCOE SUBSYSTEM libfc, libfcoe, fcoe" <fcoe-devel@open-fcoe.org>, Christoph Hellwig <hch@infradead.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, James Smart <james.smart@avagotech.com>, Paul Mackerras <paulus@samba.org>, Hannes Reinecke <hare@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, Johannes Thumshirn <jth@kernel.org>, open list:LINUX FOR POWERPC 32-BIT AND
List-Id: linux-scsi@vger.kernel.org

On 10/13/2016 08:00 AM, Johannes Thumshirn wrote:
> Provide fc_bsg_to_rport() helper that will become handy when we're moving
> from struct fc_bsg_job to a plain struct bsg_job. Also move all LLDDs to use
> the new helper.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>


For ibmvfc parts,

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
