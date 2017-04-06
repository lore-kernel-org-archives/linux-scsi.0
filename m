From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ses: don't get power status of SES device slot on probe
Date: Thu, 06 Apr 2017 12:49:14 -0400
Message-ID: <yq1d1cpqy5x.fsf@oracle.com>
References: <1491405499-5429-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41563 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755194AbdDFQtc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 12:49:32 -0400
In-Reply-To: <1491405499-5429-1-git-send-email-mauricfo@linux.vnet.ibm.com>
        (Mauricio Faria de Oliveira's message of "Wed, 5 Apr 2017 12:18:19
        -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, songliubraving@fb.com, dan.j.williams@intel.com, jejb@linux.vnet.ibm.com, axboe@fb.com, hare@suse.de, hch@lst.de, gpiccoli@linux.vnet.ibm.com


Mauricio,

> The commit 08024885a2a3 ("ses: Add power_status to SES device slot")
> introduced the 'power_status' attribute to enclosure components and
> the associated callbacks.

Applied to 4.12/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
