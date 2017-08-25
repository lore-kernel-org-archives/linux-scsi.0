From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] cxlflash: Miscellaneous fixes
Date: Fri, 25 Aug 2017 18:24:39 -0400
Message-ID: <yq1fucf5lqw.fsf@oracle.com>
References: <1503699440-61464-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28866 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933777AbdHYWYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 18:24:49 -0400
In-Reply-To: <1503699440-61464-1-git-send-email-ukrishn@linux.vnet.ibm.com>
        (Uma Krishnan's message of "Fri, 25 Aug 2017 17:17:20 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>


Uma,

> This patch series contains miscellaneous fixes. The first two address
> issues that were identified by smatch and the last patch fixes a
> regression introduced by Commit 565180723294 ("scsi: cxlflash: SISlite
> updates to support 4 ports").

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
