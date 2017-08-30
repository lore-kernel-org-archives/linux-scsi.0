From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: Fix command send race condition
Date: Tue, 29 Aug 2017 21:35:36 -0400
Message-ID: <yq1ziahzvkn.fsf@oracle.com>
References: <a765104e-3574-08f4-2667-78b59c8da27c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26040 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdH3Bfp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 21:35:45 -0400
In-Reply-To: <a765104e-3574-08f4-2667-78b59c8da27c@linux.vnet.ibm.com> (Brian
        King's message of "Tue, 29 Aug 2017 10:00:29 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: aacraid@microsemi.com, linux-scsi <linux-scsi@vger.kernel.org>, Douglas Miller <dougmill@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, RaghavaAditya.Renukunta@microsemi.com, stable@kernel.org


Brian,

> This fixes a potential race condition observed on Power systems.

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
