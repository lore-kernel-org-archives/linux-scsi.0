From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] libfc: do not flood console with messages 'libfc: queue full ...'
Date: Mon, 08 May 2017 21:21:02 -0400
Message-ID: <yq1lgq6u8ox.fsf@oracle.com>
References: <1493303103-113774-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41358 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdEIBVT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2017 21:21:19 -0400
In-Reply-To: <1493303103-113774-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Thu, 27 Apr 2017 16:25:03 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> When the FCoE sending side becomes congested libfc tries to reduce the
> queue depth on the host; however due to the built-in lag before
> attempting to ramp down the queue depth _again_ the message log is
> flooded with messages
>
> libfc: queue full, reducing can_queue to 512
>
> With this patch the message is printed only once (ie when it's
> actually changed).

Applied to 4.12/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
