From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] scsi: remove NCR_Q720 driver
Date: Fri, 6 Jul 2018 15:40:57 +0200
Message-ID: <761f3dbb-9a1a-f810-17b9-24953eb87682@suse.de>
References: <20180706133349.28508-1-jthumshirn@suse.de>
 <20180706133349.28508-3-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180706133349.28508-3-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/06/2018 03:33 PM, Johannes Thumshirn wrote:
> The NCR QUAD 720 SCSI driver depends on microchannel support, but
> microchannel support was removed from the kernel with commit
> bb8187d35f82 ("MCA: delete all remaining traces of microchannel bus
> support.") over 6 years ago.
> 
> So zap the Q720 SCSI driver as well.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/Kconfig    |  20 +--
>  drivers/scsi/Makefile   |   2 -
>  drivers/scsi/NCR_Q720.c | 376 ------------------------------------------------
>  drivers/scsi/NCR_Q720.h |  29 ----
>  4 files changed, 4 insertions(+), 423 deletions(-)
>  delete mode 100644 drivers/scsi/NCR_Q720.c
>  delete mode 100644 drivers/scsi/NCR_Q720.h
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
