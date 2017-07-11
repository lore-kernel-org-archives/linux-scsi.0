From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 02/13] mpt3sas: SGL to PRP Translation for I/Os to NVMe
 devices
Date: Tue, 11 Jul 2017 12:24:33 -0400
Message-ID: <20170711162433.GC4604@localhost.localdomain>
References: <1499763313-7214-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1499763313-7214-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499763313-7214-3-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "jejb@kernel.org" <jejb@kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sathya.Prakash@broadcom.com" <Sathya.Prakash@broadcom.com>, "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "chaitra.basappa@broadcom.com" <chaitra.basappa@broadcom.com>, "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 11, 2017 at 01:55:02AM -0700, Suganath Prabu S wrote:
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 60fa7b6..cebdd8e 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -54,6 +54,7 @@
>  #include "mpi/mpi2_raid.h"
>  #include "mpi/mpi2_tool.h"
>  #include "mpi/mpi2_sas.h"
> +#include "mpi/mpi2_pci.h"

Could you ajust your patch order for this series so each can compile? Here
in patch 2 you're including a header that's not defined until patch 12.
