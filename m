From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: check for device state in __scsi_remove_target()
Date: Mon, 18 Dec 2017 22:37:13 -0500
Message-ID: <yq1k1xjjsly.fsf@oracle.com>
References: <1513171297-58020-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44432 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757969AbdLSDh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Dec 2017 22:37:57 -0500
In-Reply-To: <1513171297-58020-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Wed, 13 Dec 2017 14:21:37 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> As it turned out device_get() doesn't use kref_get_unless_zero(),
> so we will be always getting a device pointer.
> So we need to check for the device state in __scsi_remove_target()
> to avoid tripping over deleted objects.

Applied to 4.15/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
