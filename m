From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] scsi_dh_emc: return success in clariion_std_inquiry()
Date: Wed, 22 Feb 2017 19:28:51 -0500
Message-ID: <yq1wpch7nss.fsf@oracle.com>
References: <20170221183050.GB28595@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40329 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932426AbdBWAbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 19:31:10 -0500
In-Reply-To: <20170221183050.GB28595@mwanda> (Dan Carpenter's message of "Tue,
        21 Feb 2017 21:46:37 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan,

Dan> We accidentally return an uninitialized variable on success.

Applied to 4.11/scsi-fixes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
