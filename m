From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Reduce number of scsi_test_unit_ready() retries
Date: Tue, 13 Feb 2018 21:44:26 -0500
Message-ID: <yq1vaf0nvcl.fsf@oracle.com>
References: <20180212185752.28093-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58946 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966382AbeBNCpk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:45:40 -0500
In-Reply-To: <20180212185752.28093-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Mon, 12 Feb 2018 10:57:52 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Bart,

> Make scsi_test_unit_ready() send at most as many TURs as specified
> in the 'retries' argument instead of retries * (retries + 1) / 2.

Applied to 4.17/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
