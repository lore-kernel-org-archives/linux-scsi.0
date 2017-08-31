From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: qla2xxx: Fix an integer overflow in sysfs code
Date: Wed, 30 Aug 2017 22:07:29 -0400
Message-ID: <yq1mv6gxzfi.fsf@oracle.com>
References: <20170830133035.nbkiled5hhdt26ui@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43176 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdHaCHm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 22:07:42 -0400
In-Reply-To: <20170830133035.nbkiled5hhdt26ui@mwanda> (Dan Carpenter's message
        of "Wed, 30 Aug 2017 16:30:35 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: qla2xxx-upstream@qlogic.com, shqking <shqking@gmail.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, security@kernel.org


Dan,

> The value of "size" comes from the user.  When we add "start + size"
> it could lead to an integer overflow bug.
>
> It means we vmalloc() a lot more memory than we had intended.  I
> believe that on 64 bit systems vmalloc() can succeed even if we ask it
> to allocate huge 4GB buffers.  So we would get memory corruption and
> likely a crash when we call ha->isp_ops->write_optrom() and
> ->read_optrom().

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
