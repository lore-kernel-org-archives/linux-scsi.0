From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/4] mpt3sas: Added print to notify cable running at a
 degraded speed.
Date: Fri, 20 Jan 2017 09:51:12 +0100
Message-ID: <20170120085112.GB3279@linux-x5ow.site>
References: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
 <1484840950-13656-2-git-send-email-chaitra.basappa@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484840950-13656-2-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 19, 2017 at 09:19:07PM +0530, Chaitra P B wrote:
> Driver processes the event MPI26_EVENT_ACTIVE_CABLE_DEGRADED
> when a cable is present and is running at a degraded speed
> (below the SAS3 12 Gb/s rate). Prints added
> to inform the user that the cable is not running at
> optimal speed.
> 
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> 	       Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Missing Signed-off-by for Suganath.

> ---
>  drivers/scsi/mpt3sas/mpi/mpi2_ioc.h  |    2 ++
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |   18 +++++++++++++-----
>  2 files changed, 15 insertions(+), 5 deletions(-)

Otherwise,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
