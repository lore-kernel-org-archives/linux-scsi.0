From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv6 0/8] SCSI EH cleanup
Date: Thu, 06 Apr 2017 13:09:59 -0400
Message-ID: <yq1vaqhpimw.fsf@oracle.com>
References: <1491485796-44411-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19118 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754051AbdDFRKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 13:10:18 -0400
In-Reply-To: <1491485796-44411-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Thu, 6 Apr 2017 15:36:28 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

Hannes Reinecke <hare@suse.de> writes:

Hannes,

> this is a resend of a small patchset for cleaning up SCSI EH.  Primary
> goal is to make asynchronous aborts mandatory; there hasn't been a
> single report so far where asynchronous abort won't work, so the
> 'no_async_abort' flag has never been used and will be removed with
> this patchset.  Additionally there's a cleanup to detect retries of
> failed commands and to inline commands aborts.  I've also included the
> patch to correctly reset the media access timeout counter to avoid it
> being triggered inadvertedly by several commands timing out for the
> same device.

I would still have liked to see the medium access failures be tracked on
a per-command basis. But since this is my concoction, I guess I'll have
to fix that up after I get back from vacation.

Applied 1-7 to 4.12/scsi-queue. Patch 8 needs reviews.

-- 
Martin K. Petersen	Oracle Linux Engineering
