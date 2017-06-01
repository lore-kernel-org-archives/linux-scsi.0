From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Avoid NULL pointer dereference in lpfc_els_abort()
Date: Wed, 31 May 2017 22:47:00 -0400
Message-ID: <yq1vaogl90b.fsf@oracle.com>
References: <20170524214851.25428-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44177 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdFACrJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 22:47:09 -0400
In-Reply-To: <20170524214851.25428-1-gpiccoli@linux.vnet.ibm.com> (Guilherme
        G. Piccoli's message of "Wed, 24 May 2017 18:48:51 -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, raphasil@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com


Guilherme,

> We might have a NULL pring in lpfc_els_abort(), for example on error
> recovery path, since queues are destroyed during error recovery
> mechanism.
>
> In this case, we should just drop the abort since the queues will be
> recreated anyway. This patch just verifies for NULL pointer and stop
> the abortion of the queue in case of a NULL pring.
>
> Also, this patch converts return type of lpfc_els_abort() from int to
> void, since it's not checked anywhere.

Applied to 4.12/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
