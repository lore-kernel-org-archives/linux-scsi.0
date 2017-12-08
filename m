From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH try #2] scsi_devinfo: apply to HP-rebranded the same flags as Hitachi
Date: Thu, 07 Dec 2017 21:34:11 -0500
Message-ID: <yq1k1xyuevw.fsf@oracle.com>
References: <20171117201914.8517-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752366AbdLHCjW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 21:39:22 -0500
In-Reply-To: <20171117201914.8517-1-xose.vazquez@gmail.com> (Xose Vazquez
        Perez's message of "Fri, 17 Nov 2017 21:19:14 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Takahiro Yasui <takahiro.yasui@hds.com>, Mike Christie <michaelc@cs.wisc.edu>, Matthias Rudolph <Matthias.Rudolph@hds.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>


Xose,

> 627511e3e modified some Hitachi entries:
>
>     Four models, OPEN-/DF400/DF500/DISK-SUBSYSTEM, can handle REPORT_LUN,
>     and the BLIST_REPORTLUN2 flag needs to be set. And DF600 doesn't require
>     any flags because it returns ANSI 03h (SPC).
> ~~~
>
> The same should have been done also for HP counterparts.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
