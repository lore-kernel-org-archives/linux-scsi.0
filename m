From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Add REPORTLUN2 to EMC SYMMETRIX blacklist entry
Date: Tue, 17 Oct 2017 23:00:24 -0400
Message-ID: <yq14lqxupmf.fsf@oracle.com>
References: <1508224245-130016-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29926 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758033AbdJRDAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 23:00:35 -0400
In-Reply-To: <1508224245-130016-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 17 Oct 2017 09:10:45 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Kurt Garloff <garloff@suse.de>


Hannes,

> All EMC SYMMETRIX support REPORT_LUNS, even if configured to report
> SCSI-2 for whatever reason.

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
