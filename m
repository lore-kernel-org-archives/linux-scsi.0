From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: double lock typo in lpfc_ns_rsp()
Date: Mon, 08 May 2017 21:51:01 -0400
Message-ID: <yq1vapassqi.fsf@oracle.com>
References: <20170503212215.m2t2rfrkoktugkg4@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48703 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753449AbdEIBvR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 21:51:17 -0400
In-Reply-To: <20170503212215.m2t2rfrkoktugkg4@mwanda> (Dan Carpenter's message
        of "Thu, 4 May 2017 00:22:16 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> There is a double lock bug here so this will deadlock instead of
> unlocking.

Applied to 4.12/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
