Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44EAC433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 664B664E43
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 07:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhBCHwP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 02:52:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:49033 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232324AbhBCHwO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Feb 2021 02:52:14 -0500
IronPort-SDR: xxXxpoHb+dN0yN3kJB04/qHo0VR6G6TF9+TpX6jAI6C4nlPzPuAwqMi120F9Yl0Cl9yFTvcSsb
 3rk42sg03tbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="245078093"
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="245078093"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 23:51:28 -0800
IronPort-SDR: eFdof2FlssRgAq8Fa5iupXCCkvInYVQK+hXF0eLep1xe1yz/J4YHZRzqCNc99/eSKohLTHZELU
 BdT4htmcxCBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,397,1602572400"; 
   d="scan'208";a="372285419"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.149]) ([10.237.72.149])
  by orsmga002.jf.intel.com with ESMTP; 02 Feb 2021 23:51:26 -0800
Subject: Re: [PATCH 0/4] scsi: ufs-debugfs: Add UFS Exception Event reporting
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20210119141542.3808-1-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <778bb78a-5ba1-85e8-aa71-832a0c3693f4@intel.com>
Date:   Wed, 3 Feb 2021 09:51:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210119141542.3808-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/01/21 4:15 pm, Adrian Hunter wrote:
> Hi
> 
> Here are patches to add a tracepoint for UFS Exception Events and to allow
> users to enable specific exception events without affecting the driver's
> use of exception events.
> 
> 
> Adrian Hunter (4):
>       scsi: ufs: Add exception event tracepoint
>       scsi: ufs: Add exception event definitions
>       scsi: ufs-debugfs: Add user-defined exception_event_mask
>       scsi: ufs-debugfs: Add user-defined exception event rate limiting
> 
>  drivers/scsi/ufs/ufs-debugfs.c | 90 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-debugfs.h |  2 +
>  drivers/scsi/ufs/ufs.h         | 10 ++++-
>  drivers/scsi/ufs/ufshcd.c      | 87 +++++++++++++++++++++++++---------------
>  drivers/scsi/ufs/ufshcd.h      | 26 +++++++++++-
>  include/trace/events/ufs.h     | 21 ++++++++++
>  6 files changed, 201 insertions(+), 35 deletions(-)

Any comments on this?
