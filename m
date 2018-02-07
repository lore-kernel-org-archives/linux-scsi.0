From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] qla2xxx: Bug fixes for driver
Date: Tue, 06 Feb 2018 19:45:23 -0500
Message-ID: <yq1tvut1vbw.fsf@oracle.com>
References: <20180201183318.587-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60276 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754148AbeBGApa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 19:45:30 -0500
In-Reply-To: <20180201183318.587-1-himanshu.madhani@cavium.com> (Himanshu
        Madhani's message of "Thu, 1 Feb 2018 10:33:16 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Himanshu,

> Patch#1 is the issue reported by Max using KASAN tool.
> Patch#2 fixes use of wrong queue handle for abort IOCB. 

Applied to 4.16/scsi-fixes, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
