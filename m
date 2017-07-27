From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: aacraid: Off by one NUL terminator
Date: Thu, 27 Jul 2017 12:30:42 -0400
Message-ID: <yq1wp6tvo3x.fsf@oracle.com>
References: <20170725195110.uwrzzkzvrbfqv7ld@mwanda>
        <yq1wp6uwp9c.fsf@oracle.com>
        <423FD6710FB8FB4F8728F93591889F9A5307D0DC@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22302 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbdG0Qax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2017 12:30:53 -0400
In-Reply-To: <423FD6710FB8FB4F8728F93591889F9A5307D0DC@avsrvexchmbx2.microsemi.net>
        (Dave Carroll's message of "Thu, 27 Jul 2017 16:26:17 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>


Dave,

> The issue is that we are making an inquiry response from
> container/RAID info. We could also have included a "pad" byte to
> terminate the string, as the fib data is 512 bytes. My assumption is
> that somehow back in the day, someone managed to get odd characters
> into the name.
>
> Terminating the string early would truncate the name ...

So what do you propose as a fix?

-- 
Martin K. Petersen	Oracle Linux Engineering
