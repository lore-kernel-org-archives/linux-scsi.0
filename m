From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: devinfo: fix format of the device list
Date: Wed, 17 Jan 2018 01:37:58 -0500
Message-ID: <yq1wp0hrnw9.fsf@oracle.com>
References: <20180115164723.1943-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57788 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750801AbeAQGiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 01:38:08 -0500
In-Reply-To: <20180115164723.1943-1-xose.vazquez@gmail.com> (Xose Vazquez
        Perez's message of "Mon, 15 Jan 2018 17:47:23 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>


Xose,

> Replace "" with NULL for product revision level, and
> merge TEXEL duplicate entries.

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
