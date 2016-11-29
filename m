From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] hpsa: fallback to use legacy REPORT PHYS command
Date: Tue, 29 Nov 2016 11:10:47 -0500
Message-ID: <yq1wpfmp8qg.fsf@sermon.lab.mkp.net>
References: <1479454369-100281-1-git-send-email-hare@suse.de>
        <1479454369-100281-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28229 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbcK2QLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:11:09 -0500
In-Reply-To: <1479454369-100281-3-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 18 Nov 2016 08:32:48 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Martin Wilck <martin.wilck@suse.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Older SmartArray controller do not support the extended REPORT
Hannes> PHYS command, so fallback to use the legacy version here.

Don: Please review.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
