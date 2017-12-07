From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] SCSI device blacklist handling improvements
Date: Wed, 06 Dec 2017 21:03:10 -0500
Message-ID: <yq1k1xzxpk1.fsf@oracle.com>
References: <20171204183633.32139-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57692 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdLGCDQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2017 21:03:16 -0500
In-Reply-To: <20171204183633.32139-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Mon, 4 Dec 2017 10:36:30 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Bart,

> These three patches is what I came up with after having reviewed
> recent changes in the code for handling blacklist flags
> handling. Please consider these patches for kernel v4.16.

I applied 1 and 3 to 4.16/scsi-queue. I am still not a fan of forcing
u32. That's a recipe for disaster when we add the next flag.

-- 
Martin K. Petersen	Oracle Linux Engineering
