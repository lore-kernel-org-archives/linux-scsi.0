From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: move command counter to correct place
Date: Mon, 07 Aug 2017 13:20:03 -0400
Message-ID: <yq1y3qv9tx8.fsf@oracle.com>
References: <20170728140359.15424-1-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23217 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbdHGRUP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 13:20:15 -0400
In-Reply-To: <20170728140359.15424-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Fri, 28 Jul 2017 16:03:59 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com, kashyap.desai@broadcom.com


Tomas,

> the eh reset function returns success when fw_outstanding equals zero,
> that means that the counter shouldn't be decremented
> when the driver still owns the command

Kashyap? Sumit?

-- 
Martin K. Petersen	Oracle Linux Engineering
