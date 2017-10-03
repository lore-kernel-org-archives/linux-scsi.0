From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ibmvscsis: Fix write_pending failure path
Date: Mon, 02 Oct 2017 22:51:51 -0400
Message-ID: <yq1k20d0wqg.fsf@oracle.com>
References: <20171002175938.11764-1-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43386 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdJCCv7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2017 22:51:59 -0400
In-Reply-To: <20171002175938.11764-1-bryantly@linux.vnet.ibm.com> (Bryant
        G. Ly's message of "Mon, 2 Oct 2017 12:59:38 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>


Bryant,

> For write_pending if the queue is down or client failed then return
> -EIO so that LIO can properly process the completed command. Prior we
> returned 0 since LIO could not handle it properly. Now with: target:
> Fix unknown fabric callback queue-full errors that patch addresses
> LIO's ability to handle things right.

Applied to 4.14/scsi-fixes. thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
