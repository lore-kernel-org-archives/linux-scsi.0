From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: fix io drop during the reset
Date: Thu, 14 Dec 2017 22:34:23 -0500
Message-ID: <yq1vah8mzpc.fsf@oracle.com>
References: <1513107610-24451-1-git-send-email-prasad.munirathnam@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53846 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754718AbdLODtb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 22:49:31 -0500
In-Reply-To: <1513107610-24451-1-git-send-email-prasad.munirathnam@microsemi.com>
        (Prasad B. Munirathnam's message of "Tue, 12 Dec 2017 11:40:10 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>
Cc: david.carroll@microsemi.com, raghavaaditya.renukunta@microsemi.com, martin.petersen@oracle.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org


Prasad,

> "FIB_CONTEXT_FLAG_TIMEDOUT" flag is set in aac_eh_abort to
> indicate command timeout, using the same flag in reset handler
> causes the command to timeout and the IO's were droped.

Applied to 4.15/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
