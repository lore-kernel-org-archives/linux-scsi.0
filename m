From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] Use sgl_alloc_order() and sgl_free_order()
Date: Tue, 13 Feb 2018 21:39:00 -0500
Message-ID: <yq18tbwpa63.fsf@oracle.com>
References: <20180212165819.11953-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966382AbeBNCjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 21:39:07 -0500
In-Reply-To: <20180212165819.11953-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Mon, 12 Feb 2018 08:58:16 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Bart,

> In kernel v4.16-rc1 the functions sgl_alloc_order() and
> sgl_free_order() were introduced in lib/scatterlist.c. This patch
> series introduces these functions in the ipr and pmcraid SCSI
> drivers. Please consider these patches for kernel v4.17.

Applied to 4.17/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
