From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Fix the kerneldoc for scsi_initialize_rq()
Date: Fri, 25 Aug 2017 17:39:40 -0400
Message-ID: <yq1o9r35ntv.fsf@oracle.com>
References: <20170824161109.6e23432b@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16954 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934752AbdHYVjt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 17:39:49 -0400
In-Reply-To: <20170824161109.6e23432b@lwn.net> (Jonathan Corbet's message of
        "Thu, 24 Aug 2017 16:11:09 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org


Jonathan,

> The kerneldoc comment for scsi_initialize_rq() neglected to document
> the "rq" parameter, leading to this docs build warning:

Applied to 4.14/scsi-queue. Tweaked the wording based on Bart's
comments. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
