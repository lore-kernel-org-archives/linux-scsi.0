From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] cxlflash: Miscellaneous fixes
Date: Fri, 09 Sep 2016 07:35:58 -0400
Message-ID: <yq1inu5fgpt.fsf@sermon.lab.mkp.net>
References: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51622 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754485AbcIILgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2016 07:36:15 -0400
In-Reply-To: <1472848612-64888-1-git-send-email-ukrishn@linux.vnet.ibm.com>
        (Uma Krishnan's message of "Fri, 2 Sep 2016 15:36:52 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

>>>>> "Uma" == Uma Krishnan <ukrishn@linux.vnet.ibm.com> writes:

Uma> This patch set contains miscellaneous fixes in the device cleanup
Uma> and EEH recovery paths. One of the patches simplifies the WWPN
Uma> assignment routine.

Uma> There are a couple of fixes that resolve regressions introduced by
Uma> Commit 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL
Uma> Flash cards") and Commit 888baf069f49 ("scsi: cxlflash: Add kref to
Uma> context")

Applied patches 1 and 2 to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
