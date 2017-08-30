From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: preserve sysfs updates to max_sectors_kb
Date: Tue, 29 Aug 2017 21:24:12 -0400
Message-ID: <yq1d17d26gz.fsf@oracle.com>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
        <1503090353.2622.15.camel@wdc.com>
        <4993A297653ECB4581FA5C3C31323D195B8D825D@avsrvexchmbx2.microsemi.net>
        <1503092817.2622.19.camel@wdc.com>
        <4993A297653ECB4581FA5C3C31323D195B8DBDE4@avsrvexchmbx2.microsemi.net>
        <1503345191.2571.13.camel@wdc.com>
        <4993A297653ECB4581FA5C3C31323D195B8DBE34@avsrvexchmbx2.microsemi.net>
        <4993A297653ECB4581FA5C3C31323D195B8E9103@avsrvexchmbx1.microsemi.net>
        <1504030401.2653.43.camel@wdc.com>
        <4993A297653ECB4581FA5C3C31323D195B8E9143@avsrvexchmbx1.microsemi.net>
        <4993A297653ECB4581FA5C3C31323D195B8E9191@avsrvexchmbx1.microsemi.net>
        <1504045532.2653.68.camel@wdc.com>
        <4993A297653ECB4581FA5C3C31323D195B8E9288@avsrvexchmbx1.microsemi.net>
        <1504047619.2653.75.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42735 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdH3BYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 21:24:55 -0400
In-Reply-To: <1504047619.2653.75.camel@wdc.com> (Bart Van Assche's message of
        "Tue, 29 Aug 2017 23:00:20 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "viswas.g@microsemi.com" <viswas.g@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "mahesh.rajashekhara@microsemi.com" <mahesh.rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "kevin.barnett@microsemi.com" <kevin.barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "justin.lindley@microsemi.com" <justin.lindley@microsemi.com>, "John.Hall@microsemi.com" <John.Hall@microsemi>


Bart,

> How about asking these users to create a udev rule instead of directly
> modifying max_sectors_kb in sysfs?

I looked at this for a bit last week to see if I could come up with an
elegant way to accommodate values overridden in sysfs and at the same
time honor hardware limits changing. However, it quickly gets messy
since some parameters are under the request_queue and some are scsi_disk
specific. So that involves having override flags several places. Plus
there also the whole re-stacking debacle.

So I think I prefer udev for this.

-- 
Martin K. Petersen	Oracle Linux Engineering
