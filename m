From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/24] FCoE VN2VN fixes, part two
Date: Fri, 14 Oct 2016 16:43:21 -0400
Message-ID: <yq17f9ak6fq.fsf@sermon.lab.mkp.net>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50368 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752435AbcJNUne (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 16:43:34 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Thu, 13 Oct 2016 15:10:36 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Hi all, here's now the second part of my FCoE VN2VN patchset.
Hannes> The key points are:
Hannes> - Configurable R_A_TOV/E_D_TOV
Hannes> - Rework PRLI handling to fix a longstanding bug
Hannes> - Correctly handle timed-out xids

Hannes> Additionally there are some minor fixes to get things to work
Hannes> when running with FCoE over virtio.

Hannes> Patches are relative to mkp/4.10/scsi-queue.

Hannes> As usual, comments and reviews are welcome.

Somebody please review patches 11, 13, 14, 18, 19, 20, 22, 23 and 24.

-- 
Martin K. Petersen	Oracle Linux Engineering
