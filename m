From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 6/8] MAINTAINERS: Update megaraid maintainers list
Date: Tue, 8 Nov 2016 15:50:07 +0100
Message-ID: <60504200-bdda-ec69-11e6-ab9f7894fef5@redhat.com>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
 <1477056816-7058-7-git-send-email-kashyap.desai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751534AbcKHOu0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 09:50:26 -0500
In-Reply-To: <1477056816-7058-7-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com

On 21.10.2016 15:33, Kashyap Desai wrote:
> Update MEGARAID drivers maintainers list.
>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
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

I like the phase delay, everything moved to Broadcom, so it's good time
to switch the support page to from LSI to Avago..

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

