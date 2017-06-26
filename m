From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: Fix nvme io stoppage after link bounce
Date: Mon, 26 Jun 2017 13:12:41 -0400
Message-ID: <yq1vani65bq.fsf@oracle.com>
References: <20170621173758.28058-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34544 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdFZRMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:12:51 -0400
In-Reply-To: <20170621173758.28058-1-jsmart2021@gmail.com> (James Smart's
        message of "Wed, 21 Jun 2017 10:37:58 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>


James,

> On link down, transport is calling driver to abort outstanding ios.
> Driver erroneously rejects the abort if the port indicates it isn't
> logged in - which will be the case after the link down. Thus, the io
> can't clean up. This prevents reconnection at the transport level.
>
> Fix by allowing abort to proceed.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
