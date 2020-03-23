Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7414DC4332B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 11:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 448082077D
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 11:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgCWLFI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 07:05:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:33916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727987AbgCWLFH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Mar 2020 07:05:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B5360AB98;
        Mon, 23 Mar 2020 11:05:06 +0000 (UTC)
Date:   Mon, 23 Mar 2020 12:05:06 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH 09/12] lpfc: Change default SCSI LUN QD to 64
Message-ID: <20200323110506.2izkza66c35icact@beryllium.lan>
References: <20200322181304.37655-1-jsmart2021@gmail.com>
 <20200322181304.37655-10-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322181304.37655-10-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

On Sun, Mar 22, 2020 at 11:13:01AM -0700, James Smart wrote:
> The default lun queue depth by the driver has been 30 for many years.
> However, this value, when used with more recent hardware, has actually
> throttled some tests that concentrate io on a lun.
> 
> Increase the default lun queue depth to 64.
> 
> Queue full handling, reported by the target, remains in effect and
> unchanged.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 4317c9ce7eca..ba786d08de01 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -3870,7 +3870,7 @@ LPFC_VPORT_ATTR_R(enable_da_id, 1, 0, 1,
>  # lun_queue_depth:  This parameter is used to limit the number of outstanding
>  # commands per FCP LUN. Value range is [1,512]. Default value is 30.

The documentation should also be updated here                      ^^^^

>  */
> -LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1, 512,
> +LPFC_VPORT_ATTR_R(lun_queue_depth, 64, 1, 512,
>  		  "Max number of FCP commands we can queue to a specific LUN");
>  

Thanks,
Daniel
