From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedf: Cleanup the type of io_log->op
Date: Mon, 08 May 2017 21:52:02 -0400
Message-ID: <yq1r2zyssot.fsf@oracle.com>
References: <20170503212357.cdl4e43ihpyzl2w6@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51824 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751258AbdEIBwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 21:52:18 -0400
In-Reply-To: <20170503212357.cdl4e43ihpyzl2w6@mwanda> (Dan Carpenter's message
        of "Thu, 4 May 2017 00:23:57 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> We store sc_cmd->cmnd[0] which is an unsigned char in io_log->op so
> this should also be unsigned char.  The other thing is that this is
> displayed in the debugfs:

Applied to 4.12/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
