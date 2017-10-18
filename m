From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Do not retry invalid function error
Date: Tue, 17 Oct 2017 22:48:00 -0400
Message-ID: <yq1d15luq73.fsf@oracle.com>
References: <1508224256-130260-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27360 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752543AbdJRCsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 22:48:08 -0400
In-Reply-To: <1508224256-130260-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 17 Oct 2017 09:10:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


Hannes,

> Hitachi USP-V returns 'Invalid function' when the internal staging
> mechanism encountered an error. These errors should not be retried on
> another path.

s/invalid/illegal/

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
