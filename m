From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hpsa: fix the device_id in hpsa_update_device_info()
Date: Thu, 17 Aug 2017 12:51:24 -0400
Message-ID: <yq1wp62kuib.fsf@oracle.com>
References: <20170817144444.tocisnlw6grmaf75@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41606 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbdHQQvg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 12:51:36 -0400
In-Reply-To: <20170817144444.tocisnlw6grmaf75@mwanda> (Dan Carpenter's message
        of "Thu, 17 Aug 2017 17:44:44 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Don Brace <don.brace@microsemi.com>, ". Hannes Reinecke" <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> The parentheses are in the wrong place so we specify the length as
> "sizeof(this_device->device_id) < 0" which is zero.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
