From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sg: reset 'res_in_use' after unlinking reserved array
Date: Mon, 24 Apr 2017 18:20:05 -0400
Message-ID: <yq1y3uph2i2.fsf@oracle.com>
References: <1493022396-107620-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17568 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978535AbdDXWVb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 18:21:31 -0400
In-Reply-To: <1493022396-107620-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Mon, 24 Apr 2017 10:26:36 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> Once the reserved page array is unused we can reset the 'res_in_use'
> state; here we can do a lazy update without holding the mutex as we
> only need to check against concurrent access, not concurrent release.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
