From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: make a couple of functions static
Date: Mon, 12 Jun 2017 21:05:29 -0400
Message-ID: <yq1poe8zoh2.fsf@oracle.com>
References: <20170518093524.13549-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33374 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753100AbdFMBFm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2017 21:05:42 -0400
In-Reply-To: <20170518093524.13549-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 18 May 2017 10:35:24 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org


Colin,

> functions lpfc_nvmet_cleanup_io_context and
> lpfc_nvmet_setup_io_context can be made static as they do not need to
> be in global scope.
>
> Cleans up sparse warnings:
>   "warning: symbol 'lpfc_nvmet_cleanup_io_context' was not declared.
>    Should it be static?"
>   "warning: symbol 'lpfc_nvmet_setup_io_context' was not declared.
>    Should it be static?"

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
