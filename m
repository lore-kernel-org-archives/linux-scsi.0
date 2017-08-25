From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: remove duplicated setting of gd->minors
Date: Fri, 25 Aug 2017 17:28:51 -0400
Message-ID: <yq160db72wc.fsf@oracle.com>
References: <20170818064923.GA36375@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49289 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932374AbdHYV3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 17:29:20 -0400
In-Reply-To: <20170818064923.GA36375@localhost.didichuxing.com> (weiping
        zhang's message of "Fri, 18 Aug 2017 14:49:30 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org


weiping,

> gd->minors has been set when call alloc_disk() in sd_probe.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
