From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ch: add refcounting
Date: Wed, 16 Aug 2017 21:00:39 -0400
Message-ID: <yq1ziaznh3c.fsf@oracle.com>
References: <1502807329-75158-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46974 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbdHQBAu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 21:00:50 -0400
In-Reply-To: <1502807329-75158-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 15 Aug 2017 16:28:49 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


Hannes,

> struct scsi_changer needs refcounting as the device might be removed
> while the fd is still open.

Applied to 4.14/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
