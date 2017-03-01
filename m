From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2] scsi: ufs: Factor out ufshcd_read_desc_param
Date: Wed, 01 Mar 2017 10:29:13 -0800
Message-ID: <b3b74939fba413113eef30865bc6f2ba@codeaurora.org>
References: <C8BF859FC3044844854B2CBA1ED115C11B067E@HASMSX106.ger.corp.intel.com>
 <yq1k28bvvyu.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdCASkB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 13:40:01 -0500
In-Reply-To: <yq1k28bvvyu.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Potomski, MichalX" <michalx.potomski@intel.com>, "'vinholikatti@gmail.com'" <vinholikatti@gmail.com>, "'jejb@linux.vnet.ibm.com'" <jejb@linux.vnet.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Janca, Grzegorz" <grzegorz.janca@intel.com>, "Mielczarek, SzymonX" <szymonx.mielczarek@intel.com>, linux-scsi-owner@vger.kernel.org

On 2017-02-27 19:24, Martin K. Petersen wrote:
>>>>>> "Michal" == Potomski, MichalX <michalx.potomski@intel.com> writes:
> 
> Michal> Since in UFS 2.1 specification some of the descriptor lengths
> Michal> differs from 2.0 specification and some devices, which are
> Michal> reporting spec version 2.0 have different descriptor lengths we
> Michal> can not rely on hardcoded values taken from 2.0
> Michal> specification. This patch introduces reading these lengths per
> Michal> each device from descriptor headers at probe time to ensure
> Michal> their correctness.
> 
> Subhash: I assume v2 still carries your Reviewed-by:?

Yes, v2 also looks good to me.

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
