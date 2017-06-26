From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bnx2i: missing error code in bnx2i_ep_connect()
Date: Mon, 26 Jun 2017 13:34:31 -0400
Message-ID: <yq1a84u64bc.fsf@oracle.com>
References: <20170623070200.GA7922@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21274 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFZRen (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jun 2017 13:34:43 -0400
In-Reply-To: <20170623070200.GA7922@elgon.mountain> (Dan Carpenter's message
        of "Fri, 23 Jun 2017 10:02:00 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: QLogic-Storage-Upstream@qlogic.com, Michael Chan <mchan@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> If bnx2i_map_ep_dbell_regs() then we accidentally return NULL instead
> of an error pointer.  It results in a NULL dereference in
> iscsi_if_ep_connect().

Applied to 4.13/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
