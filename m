From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] scsi: dpt_i2o: double free on error path
Date: Wed, 30 Nov 2016 19:54:46 -0500
Message-ID: <yq1wpfkh3jd.fsf@sermon.lab.mkp.net>
References: <20161130193648.GA24818@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16780 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758124AbcLAAza (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2016 19:55:30 -0500
In-Reply-To: <20161130193648.GA24818@mwanda> (Dan Carpenter's message of "Wed,
        30 Nov 2016 22:36:48 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Quentin Lambert <lambert.quentin@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> We recently introduced a kfree() in the caller for this function.
Dan> That's where, logically, you would think the kfree() should be.
Dan> Unfortunately the code was just ugly and not buggy so the static
Dan> checker warning was a false postive and introduced a double free.

Dan> I've removed the old kfree() and left the new one.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
