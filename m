From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_transport_fc: return -EBUSY for deleted vport
Date: Mon, 24 Jul 2017 22:17:55 -0400
Message-ID: <yq1eft51cq4.fsf@oracle.com>
References: <1500890976-7992-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41433 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755816AbdGYCSP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 22:18:15 -0400
In-Reply-To: <1500890976-7992-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Mon, 24 Jul 2017 12:09:36 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <james.smart@broadcom.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


Hannes,

> When trying to delete a vport via 'vport_delete' sysfs attribute
> we should be checking if the port is already in state VPORT_DELETING;
> if so there's no need to do anything.

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
