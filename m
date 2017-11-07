From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: be2iscsi: Use kasprintf
Date: Mon, 06 Nov 2017 22:59:22 -0500
Message-ID: <yq1bmke3fj9.fsf@oracle.com>
References: <1507736174-13089-1-git-send-email-himanshujha199640@gmail.com>
        <02ee3723e44b953558a3ba3100ecabaa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35414 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752650AbdKGD7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2017 22:59:30 -0500
In-Reply-To: <02ee3723e44b953558a3ba3100ecabaa@mail.gmail.com> (Jitendra
        Bhivare's message of "Mon, 6 Nov 2017 10:31:22 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: Himanshu Jha <himanshujha199640@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Subramanian Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>


Jitendra,

>> Use kasprintf instead of combination of kmalloc and sprintf.
>> Also, remove BEISCSI_MSI_NAME macro used to specify size of string as
>> kasprintf handles size computations.
>>
>> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>

> Reviewed-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
