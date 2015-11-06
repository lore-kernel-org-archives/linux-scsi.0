From: Don Brace <brace77070@gmail.com>
Subject: Re: [PATCH RESEND] hpsa: move lockup_detected attribute to host attr
Date: Fri, 6 Nov 2015 09:26:38 -0600
Message-ID: <563CC6AE.3040508@pmcs.com>
References: <1446823449-3986-1-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33013 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbbKFP0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Nov 2015 10:26:40 -0500
Received: by obbww6 with SMTP id ww6so68365837obb.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Nov 2015 07:26:39 -0800 (PST)
In-Reply-To: <1446823449-3986-1-git-send-email-thenzl@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org

On 11/06/2015 09:24 AM, Tomas Henzl wrote:
> This patch fixes a 'general protection fault' issue by
> moving the attribute to where it was likely meant.
>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>   drivers/scsi/hpsa.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 57166e68fc..6d4412359d 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -867,7 +867,6 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
>   	&dev_attr_unique_id,
>   	&dev_attr_hp_ssd_smart_path_enabled,
>   	&dev_attr_path_info,
> -	&dev_attr_lockup_detected,
>   	NULL,
>   };
>   
> @@ -879,6 +878,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
>   	&dev_attr_resettable,
>   	&dev_attr_hp_ssd_smart_path_status,
>   	&dev_attr_raid_offload_debug,
> +	&dev_attr_lockup_detected,
>   	NULL,
>   };
>   
Signed-off-by: Don Brace <don.brace@pmcs.com>
