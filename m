From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi_sysfs: Fix typo in is_bin_visible()
Date: Thu, 10 Mar 2016 10:28:53 -0500 (EST)
Message-ID: <438482616.20934560.1457623733123.JavaMail.zimbra@redhat.com>
References: <1457605526-112163-1-git-send-email-hare@suse.de> <1457623508.16707.83.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:34391 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbcCJP3D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Mar 2016 10:29:03 -0500
In-Reply-To: <1457623508.16707.83.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Reviewed-by:Laurence Oberman loberman@redhat.com>

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Ewan Milne" <emilne@redhat.com>
To: "Hannes Reinecke" <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Christoph Hellwig" <hch@lst.de>, "Johannes Thumshirn" <jthumshirn@suse.com>, "James Bottomley" <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Hannes Reinecke" <hare@suse.com>
Sent: Thursday, March 10, 2016 10:25:08 AM
Subject: Re: [PATCH] scsi_sysfs: Fix typo in is_bin_visible()

On Thu, 2016-03-10 at 11:25 +0100, Hannes Reinecke wrote:
> The test for the existence vpd_pg83 is inverted.
> 
> Fixes: 7e47976bcff ("scsi_sysfs: add 'is_bin_visible' callback")
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 58ac9c1..d805d55 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1105,7 +1105,7 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
>  	if (attr == &dev_attr_vpd_pg80 && !sdev->vpd_pg80)
>  		return 0;
>  
> -	if (attr == &dev_attr_vpd_pg83 && sdev->vpd_pg83)
> +	if (attr == &dev_attr_vpd_pg83 && !sdev->vpd_pg83)
>  		return 0;
>  
>  	return S_IRUGO;

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
