Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EACC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 07:34:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhK2Hh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 02:37:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:13533 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235403AbhK2Hf0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Nov 2021 02:35:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10182"; a="259823959"
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="259823959"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 23:32:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="594506370"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Nov 2021 23:32:05 -0800
Subject: Re: [PATCH V2] scsi: ufs: ufs-pci: Add support for Intel ADL
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
References: <20211124204218.1784559-1-adrian.hunter@intel.com>
 <4288a456-067a-b0f1-25b4-c6fcd90bd558@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <6787a445-9d5e-ebf8-23a8-eb6368bd37f8@intel.com>
Date:   Mon, 29 Nov 2021 09:32:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <4288a456-067a-b0f1-25b4-c6fcd90bd558@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/11/2021 00:50, Bart Van Assche wrote:
> On 11/24/21 12:42, Adrian Hunter wrote:
>> Add PCI ID and callbacks to support Intel Alder Lake.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> Cc: stable@vger.kernel.org # v5.15+
> 
> Not sure Greg will agree with the "Cc: stable" tag for new functionality. Anyway:

It is normal to add new PCI Ids to stable trees:

$ grep -i 'device id' Documentation/process/stable-kernel-rules.rst
 - New device IDs and quirks are also accepted.

> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thank you!
