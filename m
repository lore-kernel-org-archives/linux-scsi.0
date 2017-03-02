From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: Factor out ufshcd_read_desc_param
Date: Wed, 01 Mar 2017 21:44:29 -0500
Message-ID: <yq1tw7cqtwy.fsf@oracle.com>
References: <C8BF859FC3044844854B2CBA1ED115C11B067E@HASMSX106.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:17659 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdCBCro (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 21:47:44 -0500
In-Reply-To: <C8BF859FC3044844854B2CBA1ED115C11B067E@HASMSX106.ger.corp.intel.com>
        (MichalX Potomski's message of "Thu, 23 Feb 2017 09:05:30 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Potomski, MichalX" <michalx.potomski@intel.com>
Cc: "'vinholikatti@gmail.com'" <vinholikatti@gmail.com>, "'subhashj@codeaurora.org'" <subhashj@codeaurora.org>, "'jejb@linux.vnet.ibm.com'" <jejb@linux.vnet.ibm.com>, "'martin.petersen@oracle.com'" <martin.petersen@oracle.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Janca, Grzegorz" <grzegorz.janca@intel.com>, "Mielczarek, SzymonX" <szymonx.mielczarek@intel.com>

>>>>> "Michal'" == Potomski, MichalX <michalx.potomski@intel.com> writes:

Michal'> Since in UFS 2.1 specification some of the descriptor lengths
Michal'> differs from 2.0 specification and some devices, which are
Michal'> reporting spec version 2.0 have different descriptor lengths we
Michal'> can not rely on hardcoded values taken from 2.0
Michal'> specification. This patch introduces reading these lengths per
Michal'> each device from descriptor headers at probe time to ensure
Michal'> their correctness.

Applied to 4.11/scsi-fixes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
