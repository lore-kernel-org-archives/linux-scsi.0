From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] libsas: remove private hex2bin() implementation
Date: Wed, 03 Jan 2018 22:41:36 -0500
Message-ID: <yq1wp0yxpcf.fsf@oracle.com>
References: <20171219173727.41841-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52782 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbeADDlt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 22:41:49 -0500
In-Reply-To: <20171219173727.41841-1-andriy.shevchenko@linux.intel.com> (Andy
        Shevchenko's message of "Tue, 19 Dec 2017 19:37:27 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>


Andy,

> The function sas_parse_addr() could be easily substituted by hex2bin()
> which is in kernel library code.

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
