From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] cxlflash: Enhancements, cleanup and fixes
Date: Tue, 10 Jan 2017 00:00:55 -0500
Message-ID: <yq1ziizbjaw.fsf@oracle.com>
References: <1483711379-18188-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26078 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdAJFBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 00:01:09 -0500
In-Reply-To: <1483711379-18188-1-git-send-email-ukrishn@linux.vnet.ibm.com>
        (Uma Krishnan's message of "Fri, 6 Jan 2017 08:02:59 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

>>>>> "Uma" == Uma Krishnan <ukrishn@linux.vnet.ibm.com> writes:

Uma,

Uma> This patch series includes an enhancement to support a new command
Uma> queuing model and also cleans up prints throughout the driver. The
Uma> last patch in the series fixes a racing issue.

Uma> The series is based upon v4.10-rc2, intended for 4.11 and is
Uma> bisectable.

Uma> Matthew R. Ochs (3):
Uma>   cxlflash: Refactor context reset to share reset logic cxlflash:
Uma>   Support SQ Command Mode cxlflash: Cleanup prints

The first three patches in the series were submitted by you but do not
carry your Signed-off-by:...

-- 
Martin K. Petersen	Oracle Linux Engineering
