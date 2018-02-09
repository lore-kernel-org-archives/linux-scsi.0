From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: fix shutdown crash when init fails
Date: Fri, 09 Feb 2018 18:39:27 -0500
Message-ID: <yq17erlvikw.fsf@oracle.com>
References: <alpine.LRH.2.21.1802082158280.7112@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33172 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752521AbeBIXjl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2018 18:39:41 -0500
In-Reply-To: <alpine.LRH.2.21.1802082158280.7112@math.ut.ee> (Meelis Roos's
        message of "Fri, 9 Feb 2018 08:57:44 +0200 (EET)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>


Meelis,

> When aacraid init fails with "AAC0: adapter self-test failed.",
> shutdown leads to UBSAN warning and then oops:

Applied to 4.16/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
