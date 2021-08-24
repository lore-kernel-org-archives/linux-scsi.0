Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF83C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 11:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E618E610E8
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 11:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhHXLed (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 07:34:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:36950 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235509AbhHXLec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 07:34:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="239438801"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="239438801"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 04:33:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="643153131"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by orsmga005.jf.intel.com with ESMTP; 24 Aug 2021 04:33:45 -0700
Subject: Re: [PATCH V2] scsi: ufs: Fix ufshcd_request_sense_async() for
 Samsung KLUFG8RHDA-B2D1
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        linux-scsi@vger.kernel.org
References: <20210823050117.11608-1-adrian.hunter@intel.com>
 <yq15yvvect1.fsf@ca-mkp.ca.oracle.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <d5f5552d-257a-62ee-f0a3-55c00959e63b@intel.com>
Date:   Tue, 24 Aug 2021 14:34:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <yq15yvvect1.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/08/21 6:34 am, Martin K. Petersen wrote:
> 
> Adrian,
> 
>> Samsung KLUFG8RHDA-B2D1 does not clear the unit attention condition if
>> the length is zero. So go back to requesting all the sense data, as it
>> was before patch "scsi: ufs: Request sense data asynchronously". That
>> is simpler than creating and maintaining a quirk for affected devices.
> 
> Applied to 5.15/scsi-staging, thanks!
> 

Can you please drop V2 of this patch?  I will send a V3 with the buffer leak fixed.
