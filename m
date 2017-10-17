From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv6 0/5] scsi: Fixup blacklist handling
Date: Tue, 17 Oct 2017 01:06:06 -0400
Message-ID: <yq1wp3uwegx.fsf@oracle.com>
References: <1506954397-2237-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20852 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753252AbdJQFGU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 01:06:20 -0400
In-Reply-To: <1506954397-2237-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Mon, 2 Oct 2017 16:26:32 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org


Hannes,

> The SCSI blacklist handling seems to be rather tricky issue; everytime
> a fix is included it tends to break other devices.  This patchset
> attempt to simplify the devlist handling yet again, but this time
> implementing the framework for regression testing, too.  A patch
> adding a regression test to the blktest suite will follow.

Applied to 4.15/scsi-queue. Thanks for working on this!

-- 
Martin K. Petersen	Oracle Linux Engineering
