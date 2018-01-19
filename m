From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: sd: add new match array for cache_type
Date: Thu, 18 Jan 2018 21:41:01 -0500
Message-ID: <yq17eseo9j6.fsf@oracle.com>
References: <20180118141928.GA28320@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60454 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752855AbeASCoW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jan 2018 21:44:22 -0500
In-Reply-To: <20180118141928.GA28320@bogon.didichuxing.com> (weiping zhang's
        message of "Thu, 18 Jan 2018 22:19:32 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org


Hi Weiping,

> Add user friendly command strings sd_wce_rcd to enable/disable
> write&read cache. User can enable both write and read cache by one of
> the following commands:

I am not entirely sure what the rationale is behind your patch. Is there
some deficiency in the existing cache control interface that you are
trying to address? Or is the problem simply that it is poorly
documented?

-- 
Martin K. Petersen	Oracle Linux Engineering
