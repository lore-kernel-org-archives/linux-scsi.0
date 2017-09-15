From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] sg: fixup infoleak when using SG_GET_REQUEST_TABLE
Date: Fri, 15 Sep 2017 15:24:48 -0400
Message-ID: <yq1lglfpxxb.fsf@oracle.com>
References: <1505477116-75013-1-git-send-email-hare@suse.de>
        <1505477116-75013-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31574 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdIOTZb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 15:25:31 -0400
In-Reply-To: <1505477116-75013-3-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 15 Sep 2017 14:05:16 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, security@kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> When calling SG_GET_REQUEST_TABLE ioctl that only a half-filled table
> is returned; the remaining part will then contain stale kernel memory
> information.  This patch zeroes out the entire table to avoid this
> issue.

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
