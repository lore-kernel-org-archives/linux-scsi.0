From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2 00/19] aacraid: Patchset with reset rework and misc fixes
Date: Thu, 11 May 2017 23:07:42 -0400
Message-ID: <yq1o9uyixhd.fsf@oracle.com>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22094 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755465AbdELDH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 May 2017 23:07:57 -0400
In-Reply-To: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
        (Raghava Aditya Renukunta's message of "Wed, 10 May 2017 09:39:34
        -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com


Raghava,

> This patchset primarily focuses on tweaking and hardening the
> controller reset support for both ARC and HBA1000 devices. Now the
> driver can only reset the controller thru eh reset. Included a srb
> memory fix and pci dma allocation fix.

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
