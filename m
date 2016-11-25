From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] scsi: libfc: Remove an unneeded condition
Date: Fri, 25 Nov 2016 10:07:23 -0500
Message-ID: <yq1h96vtx78.fsf@sermon.lab.mkp.net>
References: <20161124105238.GB17225@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:32047 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755422AbcKYQOJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2016 11:14:09 -0500
In-Reply-To: <20161124105238.GB17225@mwanda> (Dan Carpenter's message of "Thu,
        24 Nov 2016 13:52:38 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> We verified that resp_code is FC_SPP_RESP_ACK earlier so we don't
Dan> need to check again here.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
