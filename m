From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Avoid triggering undefined behavior in qla2x00_mbx_completion()
Date: Tue, 30 Jan 2018 21:33:59 -0500
Message-ID: <yq1bmhag3jc.fsf@oracle.com>
References: <20180125162429.7962-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57062 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752532AbeAaCoO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 21:44:14 -0500
In-Reply-To: <20180125162429.7962-1-bart.vanassche@wdc.com> (Bart Van Assche's
        message of "Thu, 25 Jan 2018 08:24:29 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Himanshu Madhani <himanshu.madhani@cavium.com>


Bart,

> A left shift must shift less than the bit width of the left argument.
> Avoid triggering undefined behavior if ha->mbx_count == 32.

Applied to 4.16/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
