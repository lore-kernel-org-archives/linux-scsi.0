From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/5] ZBC support clenaup and fixes
Date: Mon, 16 Oct 2017 23:57:07 -0400
Message-ID: <yq18tgazass.fsf@oracle.com>
References: <20171010205425.7376-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34253 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753254AbdJQD5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2017 23:57:16 -0400
In-Reply-To: <20171010205425.7376-1-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Wed, 11 Oct 2017 05:54:20 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>


Damien,

> First part of the "scsi-mq support for ZBC disks" series that is only
> scsi specific. These patches are just cleanups with only one bug fix
> (last pacth) and do not functionally change anything.
>
> The remaining rework of the zone locking including scsi-mq support is
> still ongoing and will be sent later.

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
