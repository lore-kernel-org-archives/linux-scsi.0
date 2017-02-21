From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 1/1] scsi: ufs-qcom: remove redundant condition check
Date: Mon, 20 Feb 2017 22:06:57 -0500
Message-ID: <yq1h93o44z2.fsf@oracle.com>
References: <1487368421-22903-1-git-send-email-subhashj@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35831 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbdBUDHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2017 22:07:08 -0500
In-Reply-To: <1487368421-22903-1-git-send-email-subhashj@codeaurora.org>
        (Subhash Jadavani's message of "Fri, 17 Feb 2017 13:53:41 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, open list <linux-kernel@vger.kernel.org>

>>>>> "Subhash" == Subhash Jadavani <subhashj@codeaurora.org> writes:

Subhash,

Subhash> Dan Carpenter <dan.carpenter@oracle.com> reported this: --- The
Subhash> patch 9c46b8676271: "scsi: ufs-qcom: dump additional testbus
Subhash> registers" from Feb 3, 2017, leads to the following static
Subhash> checker warning:

You had used "---" to enclose Dan's email. But that's also the "ignore
everything beyond this point" delimiter so I ended up with an empty
commit message.

I fixed it up. Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
