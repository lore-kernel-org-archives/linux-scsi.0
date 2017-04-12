From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: remove some redundant pointer assignments
Date: Tue, 11 Apr 2017 20:44:08 -0400
Message-ID: <yq137dewj3b.fsf@oracle.com>
References: <20170406111957.17250-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33466 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdDLAoU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 20:44:20 -0400
In-Reply-To: <20170406111957.17250-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 6 Apr 2017 12:19:57 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

Colin King <colin.king@canonical.com> writes:

> There are several local or function parameter pointers that are
> being assigned NULL after a kfree where and these have no effect
> and hence can be removed.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
