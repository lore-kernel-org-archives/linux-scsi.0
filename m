Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38234C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 07:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE42A2312D
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 07:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbhASHCZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 02:02:25 -0500
Received: from mga04.intel.com ([192.55.52.120]:59542 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729511AbhASHCM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 02:02:12 -0500
IronPort-SDR: yohp0pNJrzRtd1LwIKkf6udobFMROwxeYTYjddvDytoo/6Kz6kufZFspaDPVtK965fFYieqJOb
 RcCfa+y57Yog==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="176315503"
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="176315503"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 23:01:43 -0800
IronPort-SDR: QgMEs7Dtt8OusFvqMteOPWLCuCZkED8sb01FqVvbFxjQhhxatv+Jj/OSKl1Tx/LeEs8bIhd9PK
 xAgEHIdrGekQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="350417164"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.149]) ([10.237.72.149])
  by orsmga003.jf.intel.com with ESMTP; 18 Jan 2021 23:01:38 -0800
Subject: Re: [PATCH v6 1/6] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210118201039.2398-1-huobean@gmail.com>
 <20210118201039.2398-2-huobean@gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <0a9971aa-e508-2aaa-1379-fb898471a252@intel.com>
Date:   Tue, 19 Jan 2021 09:01:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210118201039.2398-2-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/01/21 10:10 pm, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Currently UFS WriteBooster driver uses clock scaling up/down to set
> WB on/off, for the platform which doesn't support UFSHCD_CAP_CLK_SCALING,
> WB will be always on. Provide a sysfs attribute to enable/disable WB
> during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable UFS WB.

Is it so, that after a full reset, WB is always enabled again?  Is that
intended?
