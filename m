From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Replace BUG() with BUG_ON()
Date: Fri, 20 Jan 2017 16:49:12 -0500
Message-ID: <yq1mvelieqv.fsf@oracle.com>
References: <1482576667-8042-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26312 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdATVtV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jan 2017 16:49:21 -0500
In-Reply-To: <1482576667-8042-1-git-send-email-mayhs11saini@gmail.com> (Shyam
        Saini's message of "Sat, 24 Dec 2016 16:21:07 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Shyam" == Shyam Saini <mayhs11saini@gmail.com> writes:

Shyam> Replace BUG() with BUG_ON() using coccinelle

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
