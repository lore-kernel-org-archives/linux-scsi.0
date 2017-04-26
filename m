From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: scsi: ufs: Delete an error message for a failed memory allocation
 in ufshcd_memory_alloc()
Date: Wed, 26 Apr 2017 20:11:38 +0200
Message-ID: <6d4cb083-7a06-3c7d-bf98-a0386178a65d@users.sourceforge.net>
References: <75622f45-f46c-e52f-2b9e-6ff5ce32184a@users.sourceforge.net>
 <3d355c13-159a-2570-9ead-af93ad95c210@users.sourceforge.net>
 <019b6365c15b0764c156d6453648f7a2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:50493 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932715AbdDZSLw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Apr 2017 14:11:52 -0400
In-Reply-To: <019b6365c15b0764c156d6453648f7a2@codeaurora.org>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>, linux-scsi-owner@vger.kernel.org

> Although i don't know "out of memory" messages will be printed out by dmam_alloc_coherent() APIs
> or not.

Would such information belong to the programming interface documentation?

Are there any related tags or source code annotations needed?

Regards,
Markus
