From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt: Move scsi_remove_host() out of mptscsih_remove_host()
Date: Mon, 24 Apr 2017 18:21:43 -0400
Message-ID: <yq1tw5dh2fc.fsf@oracle.com>
References: <1493025752-19963-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17862 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978775AbdDXWWa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 18:22:30 -0400
In-Reply-To: <1493025752-19963-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Mon, 24 Apr 2017 11:22:32 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> Commit c5ce0ab ("scsi: sas: move scsi_remove_host call...")
> moved the call to scsi_remove_host() into sas_remove_host(),
> but forgot to modify the mpt drivers.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
