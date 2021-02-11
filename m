Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E293C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 16:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 399A864DEC
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 16:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBKQAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 11:00:45 -0500
Received: from mail-pg1-f169.google.com ([209.85.215.169]:43027 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhBKP6c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 10:58:32 -0500
Received: by mail-pg1-f169.google.com with SMTP id n10so4166567pgl.10;
        Thu, 11 Feb 2021 07:58:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mzu5SvT094Aj9xpBSbKSYnATyOFU5sYsh4lDYB93wbw=;
        b=AabvZcUJqbpXJz26ThSvFyrsUphZ6gGvuCWWc0U+v7CVSSsbtzHgiuHeBBx4WO1sIP
         qm9YnVN3J52hLCF+hHKtjUyVNQ8GU3AHyRcHr6Wx1JJnbcg1OCEj9Q0QUEZv9U1owMUu
         +EuYWnOcKqFpRyG/J/B5nE6OGiSUnd5KkNqlSxtzcjxonrYha8kZXa0fixa5iiuLrxL+
         6xiGUlx2xUhVU4dv7kThx23XalKQ0nXJZZ8xAyZkPo1XbsuhK1rvIXFhVAG0RRMi1l6t
         atzOiGPobiQUFw0Dr0uk0UT80/jL7t/h6C+izzIfR+5p21AZz/ziyK8n1PTHGtH2RA7R
         u3zQ==
X-Gm-Message-State: AOAM531T9dEmlr3DcjNJ9yR3XUK4VeKEb/tI/C5GvWV2qAyzoP0TtD4M
        CEaIB9h5qpalZM2I+v1Tp5s=
X-Google-Smtp-Source: ABdhPJzu3MAk0XclPIOwd5kfO2xIarZ3P6Mfu+VaT6x+jBwW135zJW6PpUETbhYZAYz4vclpSSADaA==
X-Received: by 2002:a63:2746:: with SMTP id n67mr8527633pgn.54.1613059061797;
        Thu, 11 Feb 2021 07:57:41 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:4fec:f2e9:7034:dfe7? ([2601:647:4000:d7:4fec:f2e9:7034:dfe7])
        by smtp.gmail.com with ESMTPSA id y2sm5673841pjw.36.2021.02.11.07.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 07:57:40 -0800 (PST)
Subject: Re: [PATCH v2] scsi: qla2xxx: Removed extra space in variable
 declaration.
To:     "Milan P. Gandhi" <mgandhi@redhat.com>,
        kernel-janitors@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        njavali@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20210211131628.GA10754@machine1>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ccf393f7-cbfc-fb8c-6f73-bb502eaa54f3@acm.org>
Date:   Thu, 11 Feb 2021 07:57:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210211131628.GA10754@machine1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/21 5:16 AM, Milan P. Gandhi wrote:
> Removed extra space in variable declaration in qla2x00_sysfs_write_nvram
> 
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
> changes v2:
>  - Added a small note about change.
> ---
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index ab45ac1e5a72..7f2db8badb6d 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -226,7 +226,7 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
>  	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
>  	    struct device, kobj)));
>  	struct qla_hw_data *ha = vha->hw;
> -	uint16_t	cnt;
> +	uint16_t cnt;
>  
>  	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size ||
>  	    !ha->isp_ops->write_nvram)

I'm not sure if such a patch is considered substantial enough to be
included upstream.

For future patches, please follow the guidelines for submitting patches
and use the imperative mood for the subject (Removed -> Remove) and do
not end the patch subject with a dot. See also
Documentation/process/submitting-patches.rst

Bart.


