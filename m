From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Handle power-on reset unit attention
Date: Wed, 18 Oct 2017 22:12:03 -0400
Message-ID: <yq1efpzrimk.fsf@oracle.com>
References: <1508224284-130390-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38715 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751091AbdJSCMO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2017 22:12:14 -0400
In-Reply-To: <1508224284-130390-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 17 Oct 2017 09:11:24 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


Hannes,

> As per SAM there is a status precedence, with any sense code 29/XX
> taking second place just after an ACA ACTIVE status.  Additionally,
> each target might prefer to not queue any unit attention conditions,
> but just report one.  Due to the above this will be that one with the
> highest precedence.  This results in the sense code 29/XX effectively
> overwriting any other unit attention.  Hence we should report the
> power-on reset to userland so that it can take appropriate action.

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
