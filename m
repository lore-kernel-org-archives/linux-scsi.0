From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/7] MAINTAINERS: Update megaraid maintainers list
Date: Mon, 17 Oct 2016 13:37:02 +0200
Message-ID: <71391130-443c-7b62-8580-e1e45637677d@suse.de>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-7-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34167 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753104AbcJQLhR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 07:37:17 -0400
In-Reply-To: <1476699850-25083-7-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com

On 10/17/2016 12:24 PM, Sumit Saxena wrote:
> Update MEGARAID drivers maintainers list.
> 
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  MAINTAINERS | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f0ee7a6..8b9117f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7612,12 +7612,12 @@ S:	Maintained
>  F:	drivers/net/wireless/mediatek/mt7601u/
>  
>  MEGARAID SCSI/SAS DRIVERS
> -M:	Kashyap Desai <kashyap.desai@avagotech.com>
> -M:	Sumit Saxena <sumit.saxena@avagotech.com>
> -M:	Uday Lingala <uday.lingala@avagotech.com>
> -L:	megaraidlinux.pdl@avagotech.com
> +M:	Kashyap Desai <kashyap.desai@broadcom.com>
> +M:	Sumit Saxena <sumit.saxena@broadcom.com>
> +M:	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> +L:	megaraidlinux.pdl@broadcom.com
>  L:	linux-scsi@vger.kernel.org
> -W:	http://www.lsi.com
> +W:	http://www.avagotech.com/support/
>  S:	Maintained
>  F:	Documentation/scsi/megaraid.txt
>  F:	drivers/scsi/megaraid.*
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
