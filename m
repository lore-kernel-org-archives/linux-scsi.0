From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: make ufshcd_get_lists_status() register operation obvious
Date: Wed, 26 Apr 2017 18:30:25 -0400
Message-ID: <yq1a872ajjy.fsf@oracle.com>
References: <20170426172858.56224-1-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38444 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031560AbdDZWah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 18:30:37 -0400
In-Reply-To: <20170426172858.56224-1-tkusumi@tuxera.com> (kusumi tomohiro's
        message of "Wed, 26 Apr 2017 20:28:58 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: subhashj@codeaurora.org, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>


> It could be just cmp 0xe instead of >>1 and cmp 0x7, with readable
> code.

Applied to 4.12/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
