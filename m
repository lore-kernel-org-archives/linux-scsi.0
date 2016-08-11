From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/10] zfcp: retain trace level for SCSI and HBA FSF
 response records
Date: Thu, 11 Aug 2016 13:21:59 +0200
Message-ID: <cb380e20-e6a3-ae51-a340-a3cda54ee343@suse.de>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
 <1470846653-90691-5-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1470846653-90691-5-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/10/2016 06:30 PM, Steffen Maier wrote:
> While retaining the actual filtering according to trace level,
> the following commits started to write such filtered records
> with a hardcoded record level of 1 instead of the actual record level:
> commit 250a1352b95e1db3216e5c5d4f4365bea5122f4a
> ("[SCSI] zfcp: Redesign of the debug tracing for SCSI records.")
> commit a54ca0f62f953898b05549391ac2a8a4dad6482b
> ("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
> 
> Now we can distinguish written records again for offline level filtering.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Fixes: 250a1352b95e ("[SCSI] zfcp: Redesign of the debug tracing for SCSI records.")
> Fixes: a54ca0f62f95 ("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
> Cc: <stable@vger.kernel.org> #2.6.38+
> Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_dbf.c | 11 ++++++-----
>  drivers/s390/scsi/zfcp_dbf.h |  4 ++--
>  drivers/s390/scsi/zfcp_ext.h |  7 ++++---
>  3 files changed, 12 insertions(+), 10 deletions(-)
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
