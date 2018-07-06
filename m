From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] scsi: remove NCR_D700 driver
Date: Fri, 6 Jul 2018 15:40:26 +0200
Message-ID: <8f655b93-0cab-5bdf-9c71-3d4ffd906ac8@suse.de>
References: <20180706133349.28508-1-jthumshirn@suse.de>
 <20180706133349.28508-2-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706133349.28508-2-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/06/2018 03:33 PM, Johannes Thumshirn wrote:
> The NCR DUAL 700 SCSI driver depends on microchannel support, but
> microchannel support was removed from the kernel with commit
> bb8187d35f82 ("MCA: delete all remaining traces of microchannel bus
> support.") over 6 years ago.
> 
> So zap the D700 SCSI driver as well.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  MAINTAINERS             |   6 -
>  drivers/scsi/Kconfig    |  12 --
>  drivers/scsi/Makefile   |   1 -
>  drivers/scsi/NCR_D700.c | 405 ------------------------------------------------
>  drivers/scsi/NCR_D700.h |  30 ----
>  5 files changed, 454 deletions(-)
>  delete mode 100644 drivers/scsi/NCR_D700.c
>  delete mode 100644 drivers/scsi/NCR_D700.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
