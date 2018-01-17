From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/8] qla2xxx: Minor fixes for the driver
Date: Wed, 17 Jan 2018 01:34:53 -0500
Message-ID: <yq11sipt2lu.fsf@oracle.com>
References: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55764 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbeAQGfC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 01:35:02 -0500
In-Reply-To: <20180116044653.20696-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Mon, 15 Jan 2018 20:46:45 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> This series has fixes for smatch warnings. Patch 3 addresses smatch
> warning reported by Dan Carpenter. We've also added a patch for async
> abort handling for initiator multiqueue in the driver along with a
> patch for NULL pointer access during probe failure.

Applied to 4.16/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
