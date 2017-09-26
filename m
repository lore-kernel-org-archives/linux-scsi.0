From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_transport_fc: Also check for NOTPRESENT in fc_remote_port_add()
Date: Mon, 25 Sep 2017 21:35:12 -0400
Message-ID: <yq11smudyy7.fsf@oracle.com>
References: <1506340043-67444-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34859 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965729AbdIZBf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 21:35:28 -0400
In-Reply-To: <1506340043-67444-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Mon, 25 Sep 2017 13:47:23 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> During failover there is a small race window between
> fc_remote_port_add() and fc_timeout_deleted_rport(); the latter drops
> the lock after setting the port to NOTPRESENT, so if
> fc_remote_port_add() is called right at that time it will fail to
> detect the existing rport and happily adding a new structure, causing
> rports to get registered twice.

Applied to 4.14/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
