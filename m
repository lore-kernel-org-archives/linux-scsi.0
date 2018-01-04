From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid driver oops with dead battery
Date: Thu, 04 Jan 2018 01:04:07 -0500
Message-ID: <yq1efn6w46g.fsf@oracle.com>
References: <alpine.LRH.2.21.1801031057510.4107@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55128 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbeADGEW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2018 01:04:22 -0500
In-Reply-To: <alpine.LRH.2.21.1801031057510.4107@math.ut.ee> (Meelis Roos's
        message of "Wed, 3 Jan 2018 11:11:09 +0200 (EET)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>


Meelis,

> The battery in my HP NetRAID-4M died of old age, and the aacraid
> driver started oopsing with NULL pointer dereference on startup after
> that.
>
> Fix it by reordering the init sequence to fill in function pointers
> before ioremapping memory, or dev->a_ops.adapter_ioremap pointer will
> be NULL.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
