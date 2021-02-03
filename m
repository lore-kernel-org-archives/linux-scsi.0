Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D5AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB68364F5C
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbhBCH2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 02:28:16 -0500
Received: from mga06.intel.com ([134.134.136.31]:40661 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhBCH2Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Feb 2021 02:28:16 -0500
IronPort-SDR: Ud1eXVJ0EJNkzntf7Olgn/tXK9vhTOZTxPfv6IVuWHrdonpxIKYYi/XZtZwBMOaKkCTf5MrCNc
 JFQyJiLBD80w==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="242510598"
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="242510598"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 23:27:30 -0800
IronPort-SDR: RAC83/tyOV4Dx5Hm/3R31G5h5YyqEQKbPo1074KIWo5D/lLrS7aG670XVQRLSpuqNEhn95aJgy
 LGkRjP/nX3iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="372279762"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.149]) ([10.237.72.149])
  by orsmga002.jf.intel.com with ESMTP; 02 Feb 2021 23:27:23 -0800
Subject: Re: [PATCH] scsi: ufs: Add total count for each error history
To:     DooHyun Hwang <dh0421.hwang@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, asutoshd@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, satyat@google.com
Cc:     grant.jung@samsung.com, jt77.jang@samsung.com,
        junwoo80.lee@samsung.com, jangsub.yi@samsung.com,
        sh043.lee@samsung.com, cw9316.lee@samsung.com,
        sh8267.baek@samsung.com, wkon.kim@samsung.com
References: <CGME20210203070741epcas1p20ce8cc24d06b3c82d735dff59f0459de@epcas1p2.samsung.com>
 <20210203065346.26606-1-dh0421.hwang@samsung.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <fb6603bb-f5ae-826f-a303-c5168a06d290@intel.com>
Date:   Wed, 3 Feb 2021 09:27:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210203065346.26606-1-dh0421.hwang@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/02/21 8:53 am, DooHyun Hwang wrote:
> Since the total error history count is unknown because the error history
> records only the number of UFS_EVENT_HIST_LENGTH, add a member to count
> each error history.
> 
> Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>

Hi

Please note that the following patch is already queued - see linux-next

                                                                                       
commit b6cacaf2044fd9b82e5ceac88d8d17e04a01982f                                                                                                                                           
Author: Adrian Hunter <adrian.hunter@intel.com>                                                                                                                                           
Date:   Thu Jan 7 09:25:38 2021 +0200                                                                                                                                                     
                                                                                                                                                                                          
    scsi: ufs: ufs-debugfs: Add error counters                                                                                                                                            
                                                                                                                                                                                          
    People testing have a need to know how many errors might be occurring over                                                                                                            
    time. Add error counters and expose them via debugfs.                                                                                                                                 
                                                                                                                                                                                          
    A module initcall is used to create a debugfs root directory for                                                                                                                      
    ufshcd-related items. In the case that modules are built-in, then                                                                                                                     
    initialization is done in link order, so move ufshcd-core to the top of the
    Makefile.
    
    Link: https://lore.kernel.org/r/20210107072538.21782-1-adrian.hunter@intel.com
    Reviewed-by: Avri Altman <avri.altman@wdc.com>
    Reviewed-by: Bean Huo <beanhuo@micron.com>
    Reviewed-by: Can Guo <cang@codeaurora.org>
    Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>


> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +++
>  drivers/scsi/ufs/ufshcd.h | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fb32d122f2e3..7ebc892553fc 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -437,6 +437,8 @@ static void ufshcd_print_evt(struct ufs_hba *hba, u32 id,
>  
>  	if (!found)
>  		dev_err(hba->dev, "No record of %s\n", err_name);
> +	else
> +		dev_err(hba->dev, "%s: total count=%u\n", err_name, e->count);
>  }
>  
>  static void ufshcd_print_evt_hist(struct ufs_hba *hba)
> @@ -4544,6 +4546,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
>  	e->val[e->pos] = val;
>  	e->tstamp[e->pos] = ktime_get();
>  	e->pos = (e->pos + 1) % UFS_EVENT_HIST_LENGTH;
> +	e->count++;
>  
>  	ufshcd_vops_event_notify(hba, id, &val);
>  }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index aa9ea3552323..df28d3fc89a5 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -450,6 +450,7 @@ struct ufs_event_hist {
>  	int pos;
>  	u32 val[UFS_EVENT_HIST_LENGTH];
>  	ktime_t tstamp[UFS_EVENT_HIST_LENGTH];
> +	u32 count;
>  };
>  
>  /**
> 

