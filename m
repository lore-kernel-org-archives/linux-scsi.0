From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] drivers/scsi/: Spelling fixes
Date: Tue, 18 Dec 2007 08:55:46 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0101052728@otce2k301.adaptec.com>
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:52843 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbXLRNzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Dec 2007 08:55:50 -0500
Content-class: urn:content-classes:message
In-Reply-To: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, AACRAID <aacraid@adaptec.com>, Andrew Vasquez <linux-driver@qlogic.com>, Brian King <brking@us.ibm.com>, IpsLinux <ipslinux@adaptec.com>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

ACK ips line change.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Joe Perches
> Sent: Monday, December 17, 2007 2:40 PM
> To: linux-kernel@vger.kernel.org
> Cc: Andrew Morton; AACRAID; Andrew Vasquez; Brian King; 
> IpsLinux; Hannes Reinecke; James E.J. Bottomley; James Smart; 
> Mike Christie; Neela Syam Kolli; linux-scsi@vger.kernel.org; 
> open-iscsi@googlegroups.com
> Subject: [PATCH] drivers/scsi/: Spelling fixes
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
. . .
>  drivers/scsi/ips.c                    |    2 +-
. . .
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 5c5a9b2..901e14b 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -1313,7 +1313,7 @@ ips_intr_copperhead(ips_ha_t * ha)
>  			cstatus.value = (*ha->func.statupd) (ha);
>  
>  		if (cstatus.fields.command_id > (IPS_MAX_CMDS - 1)) {
> -			/* Spurious Interupt ? */
> +			/* Spurious Interrupt ? */
>  			continue;
>  		}
>  
