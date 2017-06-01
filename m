From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Fix extraneous ref on sp's after adapter break
Date: Wed, 31 May 2017 22:49:47 -0400
Message-ID: <yq1r2z4l8vo.fsf@oracle.com>
References: <1495740391-33124-1-git-send-email-William.Kuzeja@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26378 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751033AbdFACuB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 22:50:01 -0400
In-Reply-To: <1495740391-33124-1-git-send-email-William.Kuzeja@stratus.com>
        (Bill Kuzeja's message of "Thu, 25 May 2017 15:26:31 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Kuzeja <William.Kuzeja@stratus.com>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com


Bill,

> Hung task timeouts can result if a qlogic board breaks unexpectedly
> while running I/O. These tasks become hung because command srb
> reference counts are not going to zero, hence the affected srbs and
> commands do not get freed. This fix accounts for this extra reference
> in the srbs in the case of a board failure.

Applied to 4.12/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
