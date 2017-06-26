From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: fix refcount error on node list
Date: Mon, 26 Jun 2017 13:13:31 -0400
Message-ID: <yq1r2y665ac.fsf@oracle.com>
References: <20170621175123.28190-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35189 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdFZRNk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:13:40 -0400
In-Reply-To: <20170621175123.28190-1-jsmart2021@gmail.com> (James Smart's
        message of "Wed, 21 Jun 2017 10:51:23 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>


James,

> A change in remote port removal introduced a spurious put which can
> cause a premature structure teardown. The affects were most notable
> when the driver attempted to unload as a null pointer would be hit.
>
> Fix by removing the unnecessary put.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
