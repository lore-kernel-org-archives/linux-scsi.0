From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Off by one in qlt_ctio_to_cmd()
Date: Wed, 12 Jul 2017 17:20:48 -0400
Message-ID: <yq160exl5cf.fsf@oracle.com>
References: <20170710084739.tjj7juaex7cb7xs5@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24079 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2017 17:20:58 -0400
In-Reply-To: <20170710084739.tjj7juaex7cb7xs5@mwanda> (Dan Carpenter's message
        of "Mon, 10 Jul 2017 11:47:40 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: qla2xxx-upstream@qlogic.com, Nicholas Bellinger <nab@linux-iscsi.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


Dan,

> There are "req->num_outstanding_cmds" elements in the
> req->outstanding_cmds[] array so the > here should be >=.

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
