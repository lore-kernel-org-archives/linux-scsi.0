From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_devinfo: apply to HP XP the same flags as Hitachi VSP
Date: Thu, 07 Dec 2017 21:34:22 -0500
Message-ID: <yq1fu8muevl.fsf@oracle.com>
References: <20171117203136.8833-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33814 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbdLHCeg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2017 21:34:36 -0500
In-Reply-To: <20171117203136.8833-1-xose.vazquez@gmail.com> (Xose Vazquez
        Perez's message of "Fri, 17 Nov 2017 21:31:36 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Takahiro Yasui <takahiro.yasui@hds.com>, Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>


Xose,

> 56f3d383f modified some Hitachi entries:
>
>    HITACHI is always supporting VPD pages, even though it's claiming to
>    support SCSI Revision 3 only.
> ~~~
>
> The same should have been done also for HP-rebranded.

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
