From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] smartpqi updates
Date: Thu, 10 Aug 2017 20:00:11 -0400
Message-ID: <yq14ltf3rec.fsf@oracle.com>
References: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18687 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdHKABB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2017 20:01:01 -0400
In-Reply-To: <150239072706.23771.1380444570336852695.stgit@brunhilda> (Don
        Brace's message of "Thu, 10 Aug 2017 13:46:33 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com, linux-scsi@vger.kernel.org


Don,

> These patches are based on Linus's tree
>
> The changes are:
>
>  - smartpqi-add-pqi-reset-quiesce-support
>    - allow driver to confirm completion of a reset.
>  - smartpqi-enhance-bmic-cache-flush
>    - can now distinguish between shutdown and power
>      management operation.
>  - smartpqi-update-pqi-passthru-ioctl
>    - update DMA direction
>  - smartpqi-cleanup-doorbell-register-usage
>    - change how sis mode is re-enabled
>  - smartpqi-update-kexec-power-down-support
>    - reset controller on shutdown
>  - smartpqi-add-in-new-controller-ids
>    - update for latest hw
>  - smartpqi-change-driver-version-to-1.1.2-125

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
