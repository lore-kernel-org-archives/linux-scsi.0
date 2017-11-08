From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: mpt3sas: cleanup _scsih_pcie_enumeration_event()
Date: Wed, 08 Nov 2017 18:17:09 -0500
Message-ID: <yq1d14sz7gq.fsf@oracle.com>
References: <20171108082101.wwseluw5bwnsgwue@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43908 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752534AbdKHXRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 18:17:16 -0500
In-Reply-To: <20171108082101.wwseluw5bwnsgwue@mwanda> (Dan Carpenter's message
        of "Wed, 8 Nov 2017 11:38:01 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> The indenting wasn't right, because the last two prints weren't
> indented far enough.  Also it used pr_info() where it was supposed to
> use pr_cont().  I reversed the if statement and pulled the code in one
> tab and did a couple other minor cleanups.

Applied to 4.15/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
