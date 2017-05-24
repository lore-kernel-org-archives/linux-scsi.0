From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/25] qla2xxx: Bug fixes and cleanups
Date: Tue, 23 May 2017 22:28:29 -0400
Message-ID: <yq1h90bvvhu.fsf@oracle.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41433 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbdEXC2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 22:28:38 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Fri, 19 May 2017 14:53:19 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> This series contains bug fixes and cleanups for the driver that we
> posted in 4.11.

In that case, please tag the fixes patches with:

Cc: <stable@vger.kernel.org> # 4.11+

> Patches 1-10 needs to go in 4.12.0-rcX. Rest of the patches can be
> queued to for-next branch.  Please let me know if the series is okay
> to be included in 4.12.0-rcX. if we are too late for big series in rcX
> then would you please queue patches 10-25 for 4.13/scsi-queue.

Patches 1-10 look innocuous enough that they should be OK. Patch
descriptions could be better, though. Please repost these ASAP.

11-25 are less critical. We still have a couple of weeks left for "big
things" in the 4.13 submission window.

-- 
Martin K. Petersen	Oracle Linux Engineering
