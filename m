From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Fix NULL pointer dereference during PCI error recovery
Date: Wed, 17 May 2017 20:21:04 -0400
Message-ID: <yq1y3tv6mmn.fsf@oracle.com>
References: <20170517220217.28337-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33948 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753845AbdERAVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 20:21:17 -0400
In-Reply-To: <20170517220217.28337-1-gpiccoli@linux.vnet.ibm.com> (Guilherme
        G. Piccoli's message of "Wed, 17 May 2017 19:02:17 -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, raphasil@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com


Guilherme,

> Recent commit on patchset "lpfc updates for 11.2.0.14" fixed an issue
> about dereferencing a NULL pointer on port reset. The specific commit,
> named "lpfc: Fix system crash when port is reset.", is missing a check
> against NULL pointer on lpfc_els_flush_cmd() though.
>
> Since we destroy the queues on adapter resets, like in PCI error
> recovery path, we need the validation present on this patch in order
> to avoid a NULL pointer dereference when trying to flush commands of
> ELS wq, after it has been destroyed (which would lead to a kernel
> oops).

Applied to 4.12/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
