Return-Path: <SRS0=0ZI3=YB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A763C4360C
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 11:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F6BC20673
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Oct 2019 11:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfJHLay (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Oct 2019 07:30:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:40578 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729876AbfJHLaw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Oct 2019 07:30:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C468AB184;
        Tue,  8 Oct 2019 11:30:47 +0000 (UTC)
Subject: Re: [PATCH v2] scsi: Add sysfs attributes for VPD pages 0h and 89h
To:     Ryan Attard <ryanattard@ryanattard.info>, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20190926162216.56591-1-ryanattard@ryanattard.info>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <6b8e7487-6592-4fd5-c98d-ff8db22c8258@suse.de>
Date:   Tue, 8 Oct 2019 13:30:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190926162216.56591-1-ryanattard@ryanattard.info>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/26/19 6:22 PM, Ryan Attard wrote:
> Add sysfs attributes for the ATA information page and
> Supported VPD Pages page.
> 
> Signed-off-by: Ryan Attard <ryanattard@ryanattard.info>
> ---
>  drivers/scsi/scsi.c        |  4 ++++
>  drivers/scsi/scsi_sysfs.c  | 19 +++++++++++++++++++
>  include/scsi/scsi_device.h |  2 ++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a7e4fba724b7..088b8ca473e6 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -485,10 +485,14 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>  		return;
>  
>  	for (i = 4; i < vpd_buf->len; i++) {
> +		if (vpd_buf->data[i] == 0x0)
> +			scsi_update_vpd_page(sdev, 0x0, &sdev->vpd_pg0);
>  		if (vpd_buf->data[i] == 0x80)
>  			scsi_update_vpd_page(sdev, 0x80, &sdev->vpd_pg80);
>  		if (vpd_buf->data[i] == 0x83)
>  			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83);
> +		if (vpd_buf->data[i] == 0x89)
> +			scsi_update_vpd_page(sdev, 0x89, &sdev->vpd_pg89);
>  	}
>  	kfree(vpd_buf);
>  }
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 8ce12ffcbb7a..eb6764f92c93 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -429,6 +429,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	struct device *parent;
>  	struct list_head *this, *tmp;
>  	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
> +	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
>  	unsigned long flags;
>  
>  	sdev = container_of(work, struct scsi_device, ew.work);
> @@ -458,16 +459,24 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	sdev->request_queue = NULL;
>  
>  	mutex_lock(&sdev->inquiry_mutex);
> +	rcu_swap_protected(sdev->vpd_pg0, vpd_pg0,
> +			   lockdep_is_held(&sdev->inquiry_mutex));
>  	rcu_swap_protected(sdev->vpd_pg80, vpd_pg80,
>  			   lockdep_is_held(&sdev->inquiry_mutex));
>  	rcu_swap_protected(sdev->vpd_pg83, vpd_pg83,
>  			   lockdep_is_held(&sdev->inquiry_mutex));
> +	rcu_swap_protected(sdev->vpd_pg89, vpd_pg89,
> +			   lockdep_is_held(&sdev->inquiry_mutex));
>  	mutex_unlock(&sdev->inquiry_mutex);
>  
> +	if (vpd_pg0)
> +		kfree_rcu(vpd_pg0, rcu);
>  	if (vpd_pg83)
>  		kfree_rcu(vpd_pg83, rcu);
>  	if (vpd_pg80)
>  		kfree_rcu(vpd_pg80, rcu);
> +	if (vpd_pg89)
> +		kfree_rcu(vpd_pg89, rcu);
>  	kfree(sdev->inquiry);
>  	kfree(sdev);
>  
> @@ -840,6 +849,8 @@ static struct bin_attribute dev_attr_vpd_##_page = {		\
>  
>  sdev_vpd_pg_attr(pg83);
>  sdev_vpd_pg_attr(pg80);
> +sdev_vpd_pg_attr(pg89);
> +sdev_vpd_pg_attr(pg0);
>  
>  static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
>  			    struct bin_attribute *bin_attr,
> @@ -1136,12 +1147,18 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
>  	struct scsi_device *sdev = to_scsi_device(dev);
>  
>  
> +	if (attr == &dev_attr_vpd_pg0 && !sdev->vpd_pg0)
> +		return 0;
> +
>  	if (attr == &dev_attr_vpd_pg80 && !sdev->vpd_pg80)
>  		return 0;
>  
>  	if (attr == &dev_attr_vpd_pg83 && !sdev->vpd_pg83)
>  		return 0;
>  
> +	if (attr == &dev_attr_vpd_pg89 && !sdev->vpd_pg89)
> +		return 0;
> +
>  	return S_IRUGO;
>  }
>  
> @@ -1183,8 +1200,10 @@ static struct attribute *scsi_sdev_attrs[] = {
>  };
>  
>  static struct bin_attribute *scsi_sdev_bin_attrs[] = {
> +	&dev_attr_vpd_pg0,
>  	&dev_attr_vpd_pg83,
>  	&dev_attr_vpd_pg80,
> +	&dev_attr_vpd_pg89,
>  	&dev_attr_inquiry,
>  	NULL
>  };
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 571ddb49b926..f4f176c79fae 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -135,8 +135,10 @@ struct scsi_device {
>  	const char * rev;		/* ... "nullnullnullnull" before scan */
>  
>  #define SCSI_VPD_PG_LEN                255
> +	struct scsi_vpd __rcu *vpd_pg0;
>  	struct scsi_vpd __rcu *vpd_pg83;
>  	struct scsi_vpd __rcu *vpd_pg80;
> +	struct scsi_vpd __rcu *vpd_pg89;
>  	unsigned char current_tag;	/* current tag */
>  	struct scsi_target      *sdev_target;   /* used only for single_lun */
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
