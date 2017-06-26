From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hptiop: make function hptiop_iop_request_callback_itl static
Date: Mon, 26 Jun 2017 13:32:27 -0400
Message-ID: <yq1efu664es.fsf@oracle.com>
References: <20170622155219.22871-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19363 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751393AbdFZRck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:32:40 -0400
In-Reply-To: <20170622155219.22871-1-colin.king@canonical.com> (Colin King's
        message of "Thu, 22 Jun 2017 16:52:19 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org


Colin,

> The function hptiop_iop_request_callback_itl does not need to be in
> global scope, so make it static.
>
> Cleans up sparse warning:
> "symbol 'hptiop_iop_request_callback_itl' was not declared. Should it
>  be static?"

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
