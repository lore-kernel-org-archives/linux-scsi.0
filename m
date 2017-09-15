From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] fcoe: Fixup device_del() inversion
Date: Thu, 14 Sep 2017 21:17:07 -0400
Message-ID: <yq1o9qcrca4.fsf@oracle.com>
References: <1504171174-37989-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46824 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbdIOBRX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2017 21:17:23 -0400
In-Reply-To: <1504171174-37989-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Thu, 31 Aug 2017 11:19:31 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>


Hannes,

> when shutting down an FCoE target system one is greeted with a flood
> of kernel warnings about
>
> sysfs group ffffffff81eff0e0 not found for kobject 'XXX'
>
> Reason here is that the fcoe driver tries to remove devices from
> a workqueue, but the NETDEV_UNREGISTER notification expects any
> calls to be synchronous as it will tear down the device once
> the notifications return.
> With this patch device removals are done synchronously, so the
> correct ordering is respected and the warnings are gone.

Please address the comments from Lee and Johannes and repost. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
