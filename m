Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA19C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6038322515
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 10:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbhAKK3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:29:17 -0500
Received: from mga05.intel.com ([192.55.52.43]:14253 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbhAKK3R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 05:29:17 -0500
IronPort-SDR: n5t3IywvKyNuJS/HVl21Q1ULdCGulutDN2twgTc+O0NASA/3MDiZry365MC1Vsg4H2o28RERI0
 0wT1UD5/axJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9860"; a="262618129"
X-IronPort-AV: E=Sophos;i="5.79,338,1602572400"; 
   d="scan'208";a="262618129"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 02:28:32 -0800
IronPort-SDR: 5MzC5HhH255GOVkG6N4933OfzmRqUt6c+42gYGNb3SJikDLDRzhfQ2OWfsTarTtSk3m7l2hTrx
 jqlyJ1kpTimw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,338,1602572400"; 
   d="scan'208";a="464119262"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.149]) ([10.237.72.149])
  by fmsmga001.fm.intel.com with ESMTP; 11 Jan 2021 02:28:29 -0800
Subject: Re: [PATCH -next] scsi: docs: ABI: sysfs-driver-ufs: rectify table
 formatting
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210111102212.19377-1-lukas.bulwahn@gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <25616ec5-3c90-2548-8516-599a73cc986b@intel.com>
Date:   Mon, 11 Jan 2021 12:28:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210111102212.19377-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/01/21 12:22 pm, Lukas Bulwahn wrote:
> Commit 0b2894cd0fdf ("scsi: docs: ABI: sysfs-driver-ufs: Add DeepSleep
> power mode") adds new entries in tables of sysfs-driver-ufs ABI
> documentation, but formatted the table incorrectly.
> 
> Hence, make htmldocs warns:
> 
>   ./Documentation/ABI/testing/sysfs-driver-ufs:{915,956}:
>   WARNING: Malformed table. Text in column margin in table line 15.
> 
> Rectify table formatting for DeepSleep power mode.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

Thank you!

> ---
> Adrian, please ack.
> 
> Martin, please pick on your scsi-next tree.
> 
>  Documentation/ABI/testing/sysfs-driver-ufs | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index e77fa784d6d8..75ccc5c62b3c 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -932,8 +932,9 @@ Description:	This entry could be used to set or show the UFS device
>  		5   UFS device will be powered off, UIC link will
>  		    be powered off
>  		6   UFS device will be moved to deep sleep, UIC link
> -		will be powered off. Note, deep sleep might not be
> -		supported in which case this value will not be accepted
> +		    will be powered off. Note, deep sleep might not be
> +		    supported in which case this value will not be
> +		    accepted
>  		==  ====================================================
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_dev_state
> @@ -973,8 +974,9 @@ Description:	This entry could be used to set or show the UFS device
>  		5   UFS device will be powered off, UIC link will
>  		    be powered off
>  		6   UFS device will be moved to deep sleep, UIC link
> -		will be powered off. Note, deep sleep might not be
> -		supported in which case this value will not be accepted
> +		    will be powered off. Note, deep sleep might not be
> +		    supported in which case this value will not be
> +		    accepted
>  		==  ====================================================
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_dev_state
> 

