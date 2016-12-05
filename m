From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3] hpsa: fallback to use legacy REPORT PHYS command
Date: Mon, 05 Dec 2016 17:14:12 -0500
Message-ID: <yq137i2vxaj.fsf@sermon.lab.mkp.net>
References: <1480674973-118250-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28274 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbcLEWOc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 17:14:32 -0500
In-Reply-To: <1480674973-118250-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 2 Dec 2016 11:36:13 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Older SmartArray controllers (eg SmartArray 64xx) do not support
Hannes> the extended REPORT PHYS command, so fallback to use the legacy
Hannes> version here.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
