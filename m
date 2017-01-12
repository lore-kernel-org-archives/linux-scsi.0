From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/4] cxlflash: Enhancements, cleanup and fixes
Date: Wed, 11 Jan 2017 22:55:58 -0500
Message-ID: <yq1h955nd81.fsf@oracle.com>
References: <1484183898-22714-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:42913 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdALD5f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 22:57:35 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0C3vCVD015807
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Jan 2017 03:57:12 GMT
In-Reply-To: <1484183898-22714-1-git-send-email-ukrishn@linux.vnet.ibm.com>
        (Uma Krishnan's message of "Wed, 11 Jan 2017 19:18:18 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

>>>>> "Uma" == Uma Krishnan <ukrishn@linux.vnet.ibm.com> writes:

Uma> This patch series includes an enhancement to support a new command
Uma> queuing model and also cleans up prints throughout the driver. The
Uma> last patch in the series fixes a racing issue.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
