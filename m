From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pmcraid: use normal copy_from_user
Date: Mon, 24 Apr 2017 18:13:26 -0400
Message-ID: <yq1bmrlihdl.fsf@oracle.com>
References: <20170420175549.3435196-1-arnd@arndb.de>
        <20170421220250.2427519-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50506 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978567AbdDXWNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 18:13:39 -0400
In-Reply-To: <20170421220250.2427519-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Sat, 22 Apr 2017 00:02:31 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Berg <johannes.berg@intel.com>, Baoyou Xie <baoyou.xie@linaro.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Arnd,

> As pointed out by Al Viro for my previous series, the driver has no need
> to call access_ok() and __copy_from_user()/__copy_to_user(). Changing
> it to regular copy_from_user()/copy_to_user() simplifies the code without
> any real downsides, making it less error-prone at best.
>
> This patch by itself also addresses the warning about the access_ok()
> macro on MIPS, but both fixes improve the code, so ideally we apply
> them both.

Applied patches 1, 3, 4 as well as this one to 4.12/scsi-queue. I took
Christoph's version of patch 2.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
