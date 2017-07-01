From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: flush eh_work when eh_work scheduled.
Date: Sat, 01 Jul 2017 16:51:45 -0400
Message-ID: <yq1shifx4m6.fsf@oracle.com>
References: <20170624111432.11852-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45505 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751978AbdGAUwy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jul 2017 16:52:54 -0400
In-Reply-To: <20170624111432.11852-1-zangleigang@hisilicon.com> (Zang
        Leigang's message of "Sat, 24 Jun 2017 19:14:32 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org


Zang,

> Forget a condition: eh_work scheduled but do not start to work.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
