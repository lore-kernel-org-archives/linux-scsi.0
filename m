From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedi: fix missing return error code check on call to qedi_setup_int
Date: Tue, 28 Feb 2017 21:56:13 -0500
Message-ID: <yq11suhu2lu.fsf@oracle.com>
References: <20170228110248.19290-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:40042 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdCAD1Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 22:27:25 -0500
In-Reply-To: <20170228110248.19290-1-colin.king@canonical.com> (Colin King's
        message of "Tue, 28 Feb 2017 11:02:48 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin> The call to qedi_setup_int is not updating the return code rc yet
Colin> rc is being checked for an error. Fix this by assigning rc to the
Colin> return code from the call to qedi_setup_int.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
