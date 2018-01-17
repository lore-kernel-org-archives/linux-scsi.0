From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][scsi-next] scsi: mpt3sas: make function _get_st_from_smid static
Date: Wed, 17 Jan 2018 01:02:33 -0500
Message-ID: <yq1r2qpt43q.fsf@oracle.com>
References: <20180111165539.1248-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35718 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbeAQGCl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 01:02:41 -0500
In-Reply-To: <20180111165539.1248-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 11 Jan 2018 16:55:39 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org


Colin,

> The function _get_st_from_smid is local to the source and does
> not need to be in global scope, so make it static.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
