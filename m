From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_error.c: DID_SOFT_ERROR comment clean up
Date: Tue, 31 Oct 2017 12:47:24 -0400
Message-ID: <yq1r2tj9sdf.fsf@oracle.com>
References: <1509399490.5866.3.camel@petroskoutoupis.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49783 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdJaQrb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 12:47:31 -0400
In-Reply-To: <1509399490.5866.3.camel@petroskoutoupis.com> (Petros Koutoupis's
        message of "Mon, 30 Oct 2017 16:38:10 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Petros Koutoupis <petros@petroskoutoupis.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Petros,

> Updated comment. We are keeping track of maximum number of retries per
> command via retries/allowed in struct scsi_cmnd. Corrected comment
> positioning.

This didn't apply to 4.15/scsi-queue. I applied it by hand.

-- 
Martin K. Petersen	Oracle Linux Engineering
