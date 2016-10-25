From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/20] libfc callback cleanup
Date: Mon, 24 Oct 2016 20:37:42 -0400
Message-ID: <yq1eg35b6w9.fsf@sermon.lab.mkp.net>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32959 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbcJYAiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2016 20:38:04 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 18 Oct 2016 10:01:34 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Hi all, it has been bugging me for a while that libfc has tons
Hannes> of callbacks in an attempt to abstract things away. But as it
Hannes> turned out no-one ever used those, rendering them quite
Hannes> pointless.  As I got some time to kill on the train back from
Hannes> Vienna I've decided to finally kill them and call the functions
Hannes> directly.

Applied to 4.10/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
