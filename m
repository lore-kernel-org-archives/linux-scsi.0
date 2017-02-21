From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2 00/15] aacraid: Fixes and enhancements for arc family
Date: Mon, 20 Feb 2017 21:53:43 -0500
Message-ID: <yq1poic45l4.fsf@oracle.com>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32917 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdBUCx6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 21:53:58 -0500
In-Reply-To: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
        (Raghava Aditya Renukunta's message of "Thu, 16 Feb 2017 12:51:09
        -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

>>>>> "Raghava" == Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com> writes:

Raghava> This patch set contains issue fixes, enhancements and other
Raghava> misc changes.  The majority of the fixes are a direct outcome
Raghava> of testing and work done on the adapter reset
Raghava> mechanism. Initially it just had IOP reset and then was
Raghava> augmented with IWBR soft hardware resets in the previous patch
Raghava> set. The reset mechanism is triggered in 2 paths, one is from
Raghava> the eh handler from the kernel and the other is from the
Raghava> driver's internal periodic health checkup.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
