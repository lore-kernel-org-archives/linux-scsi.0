From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: csiostor: fix use after free in csio_hw_use_fwconfig()
Date: Thu, 18 May 2017 21:38:17 -0400
Message-ID: <yq1h90h4ody.fsf@oracle.com>
References: <1495033243-20262-1-git-send-email-varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46252 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933253AbdESBi2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2017 21:38:28 -0400
In-Reply-To: <1495033243-20262-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Wed, 17 May 2017 20:30:43 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, indranil@chelsio.com, rajesh.kumar@chelsio.com


Varun,

> mbp pointer is passed to csio_hw_validate_caps() so call
> mempool_free() after calling csio_hw_validate_caps().

Applied to 4.12/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
