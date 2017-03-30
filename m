From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] scsi: ufs: make ufshcd_is_{device_present,hba_active}() return bool
Date: Wed, 29 Mar 2017 22:44:10 -0400
Message-ID: <yq1bmsj4h6t.fsf@oracle.com>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38559 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752733AbdC3CoU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 22:44:20 -0400
In-Reply-To: <20170328134929.25599-1-tkusumi@tuxera.com> (kusumi tomohiro's
        message of "Tue, 28 Mar 2017 16:49:24 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>

kusumi.tomohiro@gmail.com writes:

> ufshcd driver generally uses bool for is_xxx type things instead of int,
> so conform to its style.

Applied patches 1-6 to 4.12/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
