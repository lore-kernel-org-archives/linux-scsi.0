From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ibmvscsis: add DRC indices to debug statements
Date: Mon, 04 Dec 2017 22:32:37 -0500
Message-ID: <yq14lp54zoq.fsf@oracle.com>
References: <20171204220728.94613-1-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55419 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbdLEDcs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 22:32:48 -0500
In-Reply-To: <20171204220728.94613-1-bryantly@linux.vnet.ibm.com> (Bryant
        G. Ly's message of "Mon, 4 Dec 2017 16:07:28 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Brad Warrum <bwarrum@us.ibm.com>


Bryant,

> Where applicable, changes pr_debug, pr_info, pr_err, etc. calls
> to the dev_* versions.  This adds the DRC index of the device to the
> corresponding trace statement.

Applied to 4.16/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
