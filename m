From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: Fix typo in blink status
Date: Mon, 06 Mar 2017 22:24:05 -0500
Message-ID: <yq17f41lqga.fsf@oracle.com>
References: <20170302172133.3503-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41587 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754842AbdCGD1R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 22:27:17 -0500
In-Reply-To: <20170302172133.3503-1-RaghavaAditya.Renukunta@microsemi.com>
        (Raghava Aditya Renukunta's message of "Thu, 2 Mar 2017 09:21:33
        -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

>>>>> "Raghava" == Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com> writes:

Raghava> The return status of the adapter check on KERNEL_PANIC is
Raghava> supposed to be the upper 16 bits of the OMR status register.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
