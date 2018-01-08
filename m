From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] scsi: hpsa: Use vsnprintf extension %phN
Date: Mon, 08 Jan 2018 10:54:14 -0500
Message-ID: <yq1r2r0pcrd.fsf@oracle.com>
References: <20171219170959.40768-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48642 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934187AbeAHPzZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 10:55:25 -0500
In-Reply-To: <20171219170959.40768-1-andriy.shevchenko@linux.intel.com> (Andy
        Shevchenko's message of "Tue, 19 Dec 2017 19:09:59 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org


Andy,

> Using this extension reduces the object size.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
