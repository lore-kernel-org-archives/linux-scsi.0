From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Kconfig fix
Date: Thu, 29 Sep 2016 21:57:33 -0400
Message-ID: <yq1r382up2q.fsf@sermon.lab.mkp.net>
References: <68bc8a512ea93a41be92f83fc664efd724855ced.1474631254.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23392 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935310AbcI3B5k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2016 21:57:40 -0400
In-Reply-To: <68bc8a512ea93a41be92f83fc664efd724855ced.1474631254.git.jpinto@synopsys.com>
        (Joao Pinto's message of "Fri, 23 Sep 2016 12:52:52 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: linux-scsi@vger.kernel.org, Manjunath.MB@synopsys.com

>>>>> "Joao" == Joao Pinto <Joao.Pinto@synopsys.com> writes:

Joao> Currently if we have PCI and UFSHCD configured in the kernel, both
Joao> SCSI_UFS_DWC_TC_PCI and SCSI_UFSHCD_PCI show up, which is not
Joao> correct.  This patch changes the UFS Kconfig to assure hierarchy
Joao> between the 2 options.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
