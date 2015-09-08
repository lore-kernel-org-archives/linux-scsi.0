From: Don Brace <Don.Brace@pmcs.com>
Subject: RE: [PATCH] hpsa: move lockup_detected attribute to host attr
Date: Tue, 8 Sep 2015 19:34:29 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB7CD3D454@BBYEXM02.pmc-sierra.internal>
References: <1441642489-5036-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:39420 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbbIHTeb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2015 15:34:31 -0400
In-Reply-To: <1441642489-5036-1-git-send-email-thenzl@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Justin Lindley <Justin.Lindley@pmcs.com>, "elliott@hp.com" <elliott@hp.com>, Kevin Barnett <Kevin.Barnett@pmcs.com>, Scott Teel <Scott.Teel@pmcs.com>, "hch@infradead.org" <hch@infradead.org>

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Monday, September 07, 2015 11:15 AM
> To: linux-scsi@vger.kernel.org
> Cc: Don Brace; Justin Lindley; elliott@hp.com; Kevin Barnett; Scott Teel;
> hch@infradead.org
> Subject: [PATCH] hpsa: move lockup_detected attribute to host attr
> 
> This patch fixes a 'general protection fault' issue by
> moving the attribute to where it was likely meant.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/hpsa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 40669f8dd0..0f96bf1082 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -848,7 +848,6 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
>  	&dev_attr_unique_id,
>  	&dev_attr_hp_ssd_smart_path_enabled,
>  	&dev_attr_path_info,
> -	&dev_attr_lockup_detected,
>  	NULL,
>  };
> 
> @@ -860,6 +859,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
>  	&dev_attr_resettable,
>  	&dev_attr_hp_ssd_smart_path_status,
>  	&dev_attr_raid_offload_debug,
> +	&dev_attr_lockup_detected,
>  	NULL,
>  };
> 
> --
> 2.4.3

Signed-off-by: Don Brace <don.brace@pmcs.com>
