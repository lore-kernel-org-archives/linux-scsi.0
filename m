From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Factor out ufshcd_read_desc_param
Date: Wed, 22 Feb 2017 19:25:53 -0500
Message-ID: <yq160k192i6.fsf@oracle.com>
References: <C8BF859FC3044844854B2CBA1ED115C11B0163@HASMSX106.ger.corp.intel.com>
        <C8BF859FC3044844854B2CBA1ED115C11B053C@HASMSX106.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39483 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934038AbdBWA0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 19:26:17 -0500
In-Reply-To: <C8BF859FC3044844854B2CBA1ED115C11B053C@HASMSX106.ger.corp.intel.com>
        (MichalX Potomski's message of "Tue, 21 Feb 2017 07:36:16 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Potomski, MichalX" <michalx.potomski@intel.com>
Cc: "'vinholikatti@gmail.com'" <vinholikatti@gmail.com>, "'subhashj@codeaurora.org'" <subhashj@codeaurora.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Janca, Grzegorz" <grzegorz.janca@intel.com>, "Mielczarek, SzymonX" <szymonx.mielczarek@intel.com>

>>>>> "Michal" == Potomski, MichalX <michalx.potomski@intel.com> writes:

Michal,

Michal> Since in UFS 2.1 specification some of the descriptor lengths
Michal> differs from 2.0 specification and some devices, which are
Michal> reporting spec version 2.0 have different descriptor lengths we
Michal> can not rely on hardcoded values taken from 2.0
Michal> specification. This patch introduces reading these lengths per
Michal> each device from descriptor headers at probe time to ensure
Michal> their correctness.

This doesn't apply to 4.11/scsi-fixes. Please rebase and resend.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
