From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/10] zfcp: trace on request for open and close of WKA
 port
Date: Thu, 11 Aug 2016 13:22:58 +0200
Message-ID: <e99f0614-2c58-22cf-772a-39a291e9441b@suse.de>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
 <1470846653-90691-7-git-send-email-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1470846653-90691-7-git-send-email-maier@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 08/10/2016 06:30 PM, Steffen Maier wrote:
> Since commit a54ca0f62f953898b05549391ac2a8a4dad6482b
> ("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
> HBA records no longer contain WWPN, D_ID, or LUN
> to reduce duplicate information which is already in REC records.
> In contrast to "regular" target ports, we don't use recovery to open
> WKA ports such as directory/nameserver, so we don't get REC records.
> Therefore, introduce pseudo REC running records without any
> actual recovery action but including D_ID of WKA port on open/close.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Fixes: a54ca0f62f95 ("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
> Cc: <stable@vger.kernel.org> #2.6.38+
> Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_dbf.c | 32 ++++++++++++++++++++++++++++++++
>  drivers/s390/scsi/zfcp_ext.h |  1 +
>  drivers/s390/scsi/zfcp_fsf.c |  8 ++++++--
>  3 files changed, 39 insertions(+), 2 deletions(-)
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
