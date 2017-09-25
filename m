From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_transport_fc: set scsi_target_id upon rescan
Date: Mon, 25 Sep 2017 19:00:35 -0400
Message-ID: <yq1tvzqe63w.fsf@oracle.com>
References: <1505890733-48870-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26842 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934368AbdIYXAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 19:00:54 -0400
In-Reply-To: <1505890733-48870-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Wed, 20 Sep 2017 08:58:53 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Smart <james.smart@broadcom.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> When an rport is found in the bindings array there is no guarantee
> that it had been a target port, so we need to call
> fc_remote_port_rolechg() here to ensure the scsi_target_id is set
> correctly.  Otherwise the port will never be scanned.

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
