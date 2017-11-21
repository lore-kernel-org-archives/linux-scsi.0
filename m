From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hpsa: remove an unecessary NULL check
Date: Mon, 20 Nov 2017 21:31:32 -0500
Message-ID: <yq1ine4nz0b.fsf@oracle.com>
References: <20171107130131.3zohbeoobjxbqmdz@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23573 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751389AbdKUCbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 21:31:44 -0500
In-Reply-To: <20171107130131.3zohbeoobjxbqmdz@mwanda> (Dan Carpenter's message
        of "Tue, 7 Nov 2017 16:01:32 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


> device->scsi3addr[] is an array, not a pointer, so it can't be NULL.
> I've removed the check.

Microsemi folks, please review. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
