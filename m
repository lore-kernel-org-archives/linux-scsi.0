From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi/mac_esp: Replace bogus memory barrier with spinlock
Date: Tue, 25 Apr 2017 12:53:05 -0400
Message-ID: <yq1wpa8e8em.fsf@oracle.com>
References: <1ecb1ec37388c616335dba37b42b4a7676df6c1e.1491115954.git.fthain@telegraphics.com.au>
        <yq1lgqph21t.fsf@oracle.com>
        <c4715424-f497-9fe0-a3a4-22efb1076046@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35640 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1432316AbdDYQxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 12:53:20 -0400
In-Reply-To: <c4715424-f497-9fe0-a3a4-22efb1076046@gmail.com> (Michael
        Schmitz's message of "Tue, 25 Apr 2017 14:14:47 +1200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Finn Thain <fthain@telegraphics.com.au>, Ondrej Zary <linux@rainbow-software.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Michael,

> looks good to me, so:
>
> Reviewed-By: Michael Schmitz <schmitzmic@gmail.com>

Applied to 4.12/scsi-queue.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
