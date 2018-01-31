From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_dh: Document alua_rtpg_queue() arguments
Date: Tue, 30 Jan 2018 21:58:23 -0500
Message-ID: <yq1y3keenu8.fsf@oracle.com>
References: <20180123235003.25971-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38736 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbeAaC6g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 21:58:36 -0500
In-Reply-To: <20180123235003.25971-1-bart.vanassche@wdc.com> (Bart Van
        Assche's message of "Tue, 23 Jan 2018 15:50:03 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>


Bart,

> Since commit 3a025e1d1c2e ("Add optional check for bad kernel-doc
> comments") building with W=1 causes warnings to appear for issues
> in kernel-doc headers. This patch avoids that the following warnings
> are reported when building with W=1:

Applied to 4.16/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
