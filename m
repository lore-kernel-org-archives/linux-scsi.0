From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Use after free in lpfc_rq_buf_free()
Date: Tue, 28 Nov 2017 23:47:29 -0500
Message-ID: <yq1shcxhese.fsf@oracle.com>
References: <20171122085803.lwajodogeyovzjoa@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27644 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbdK2Erh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Nov 2017 23:47:37 -0500
In-Reply-To: <20171122085803.lwajodogeyovzjoa@mwanda> (Dan Carpenter's message
        of "Wed, 22 Nov 2017 11:58:03 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> The error message dereferences "rqb_entry" so we need to print it first
> and then free the buffer.

Applied to 4.15/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
