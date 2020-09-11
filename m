Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E72C2BC11
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 15:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A2ED20770
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 15:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgIKPd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 11:33:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:53188 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgIKPdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 11:33:49 -0400
IronPort-SDR: 8PLDrsbdgt72oSt5/WgO4Mpt7bAw2tbAk5sEFsffMwcKkpKPm6IgTOBHgIsJowb9dSiIQhq9NH
 ofvrZ44aQHpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="243578500"
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="243578500"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 07:01:35 -0700
IronPort-SDR: QQgLCeVX9kCsYDZoRTSgdRIBcUe+kmyz1tNdGnjn0NXylpLc1SMG6Oo3tTnf0C4W5K/yccFnGP
 PXfGAG1XnuLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="329788215"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.190]) ([10.237.72.190])
  by fmsmga004.fm.intel.com with ESMTP; 11 Sep 2020 07:01:33 -0700
Subject: Re: [PATCH V2] scsi: ufs-pci: Add LTR support for Intel controllers
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
References: <20200827072030.24655-1-adrian.hunter@intel.com>
 <yq14kohexka.fsf@ca-mkp.ca.oracle.com>
 <dc615e02-18a3-334d-dbc4-8aba94e4be6b@intel.com>
 <a27fa387-356c-82e1-a49f-62602336589e@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <841d40b4-1181-2bd3-2c7f-4c00e76cbe60@intel.com>
Date:   Fri, 11 Sep 2020 17:01:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <a27fa387-356c-82e1-a49f-62602336589e@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/09/20 5:06 pm, Adrian Hunter wrote:
> On 2/09/20 12:27 pm, Adrian Hunter wrote:
>> On 2/09/20 5:12 am, Martin K. Petersen wrote:
>>>
>>> Adrian,
>>>
>>>> Intel host controllers support the setting of latency tolerance.
>>>> Accordingly, implement the PM QoS ->set_latency_tolerance() callback. The
>>>> raw register values are also exposed via debugfs.
>>>
>>> Does not apply to 5.10/scsi-queue. Please rebase. Thanks!
>>>
>>
>> Hi
>>
>> Thanks for processing this.
>>
>> The 5.10/scsi-queue branch seems to be missing the following fix.  If you cherry
>> pick that, then it applies.
> 
> Now there seem to be conflicts between 5.10/scsi-queue and v5.9-rc4.
> I am not sure what I can do?

Now I see it does apply to James' for-next branch.  Can it be applied there?
