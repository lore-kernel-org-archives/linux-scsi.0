From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv4 0/6] sanitize sg
Date: Tue, 11 Apr 2017 20:56:43 -0400
Message-ID: <yq1shlev3xw.fsf@oracle.com>
References: <1491550457-78302-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36353 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751411AbdDLA46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 20:56:58 -0400
In-Reply-To: <1491550457-78302-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 7 Apr 2017 09:34:11 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, dgilbert@interlog.com, Johannes Thumshirn <jth@kernel.org>


Hannes,

> the infamous syzkaller incovered some more issues in the sg driver.
> This patchset fixes those two issues (and adds a fix for yet another
> potential issue; checking for a NULL dxferp when dxfer_len is not 0).
> It also removes handling of the SET_FORCE_LOW_DMA ioctl, which never
> worked since the initial git checkin. And does some code cleanup by
> removing the private list implementation, using standard lists
> instead.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
