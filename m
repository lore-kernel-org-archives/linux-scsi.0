From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/5] qla2xxx: Patches for scsi-misc
Date: Mon, 16 Oct 2017 23:08:17 -0400
Message-ID: <yq1fuai1nfi.fsf@oracle.com>
References: <20171013163407.8038-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20208 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754825AbdJQDIY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2017 23:08:24 -0400
In-Reply-To: <20171013163407.8038-1-himanshu.madhani@cavium.com> (Madhani
        Madhani's message of "Fri, 13 Oct 2017 09:34:02 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Madhani" <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Madhani,

> This series adds support for INTx mode for qla2xxx driver. Also, adds
> support for N2N login for FC-NVMe.
>
> Please apply to 4.15/scsi-queue at your earliest convenience.

Several of the patches had bad whitespace. Please run checkpatch before
submitting. Also, you did not apply the review tags you got from
Johannes for v1.

I fixed those things up. Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
