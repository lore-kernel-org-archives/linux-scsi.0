From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/37] qla2xxx: driver updates
Date: Thu, 04 Jan 2018 00:59:36 -0500
Message-ID: <yq1mv1uw4dz.fsf@oracle.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34697 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbeADF7q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2018 00:59:46 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Thu, 28 Dec 2017 12:33:08 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Hi Himanshu!

> This series contains number of improvments in handling of switch
> registration commands in the driver. Switch commands are now submitted
> via IOCB patch asynchronously instead of mailbox interface.

Applied to 4.16/scsi-queue. However, ...

>  17 files changed, 2891 insertions(+), 1131 deletions(-)

Next time please don't submit a series this big. It is really, really
painful to review. Especially when some of the patches are huge.

I would much rather have 3-4 sets of 8-10 patches scattered throughout
the development cycle. Or a slow, steady trickle of bug fixes with maybe
a few bigger "new feature" series of logically related patches posted
separately to facilitate review.

Thanks!
Martin

-- 
Martin K. Petersen	Oracle Linux Engineering
