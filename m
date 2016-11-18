From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: use bus '3' for legacy HBA devices
Date: Thu, 17 Nov 2016 20:28:23 -0500
Message-ID: <yq1zikx7f0o.fsf@sermon.lab.mkp.net>
References: <1479381356-94616-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26399 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbcKRB2z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2016 20:28:55 -0500
In-Reply-To: <1479381356-94616-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Thu, 17 Nov 2016 12:15:56 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Don Brace <don.brace@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Jack Suter <jack@suter.io>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Older controllers use SCSI target id '0' for the first internal
Hannes> disk. As the controllers are now placed on the same bus than the
Hannes> internal disks this leads to a clash with the SCSI target id of
Hannes> controller.  This patch checks the SCSI revision, and moves
Hannes> older controller to bus '3' to be compatible with older releases
Hannes> and avoid this problem.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
