From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 2/2] scsi: mpt3sas: remove a stray KERN_INFO
Date: Wed, 08 Nov 2017 18:18:17 -0500
Message-ID: <yq18tfgz7eu.fsf@oracle.com>
References: <20171108083819.u2yufaeamh2vffac@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23656 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753024AbdKHXS1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 18:18:27 -0500
In-Reply-To: <20171108083819.u2yufaeamh2vffac@mwanda> (Dan Carpenter's message
        of "Wed, 8 Nov 2017 11:38:20 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> pr_info() has a KERN_INFO already so the second KERN_INFO isn't needed.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
