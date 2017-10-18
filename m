From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Add TRY_VPD_PAGES to HITACHI OPEN-V blacklist entry
Date: Tue, 17 Oct 2017 22:47:32 -0400
Message-ID: <yq1h8uxuq7v.fsf@oracle.com>
References: <1508224233-129972-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27258 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752543AbdJRCrp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 22:47:45 -0400
In-Reply-To: <1508224233-129972-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 17 Oct 2017 09:10:33 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> HITACHI is always supporting VPD pages, even though it's claiming to
> support SCSI Revision 3 only.

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
