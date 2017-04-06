From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: hpsa patches in mkp/4.12/scsi-queue and mkp/4.11/scsi-fixes
Date: Thu, 06 Apr 2017 13:05:30 -0400
Message-ID: <yq1ziftpiud.fsf@oracle.com>
References: <1491481189.5348.12.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26267 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933569AbdDFRFl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 13:05:41 -0400
In-Reply-To: <1491481189.5348.12.camel@suse.com> (Martin Wilck's message of
        "Thu, 06 Apr 2017 14:19:49 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

Martin Wilck <mwilck@suse.com> writes:

Martin,

> I noticed that the following commits
>
> eb94588dabec scsi: hpsa: fix volume offline state
> 2ef288498087 scsi: hpsa: do not timeout reset operations
> 87b9e6aa87d9 scsi: hpsa: limit outstanding rescans
> 85b29008d8af scsi: hpsa: update check for logical volume status
>
> are included in mkp/4.11/scsi-fixes but not in mkp/4.12/scsi-queue.
> Is there a specific reason for that?

scsi-fixes and scsi-queue are usually forked from linus/master at the
about same time after the merge window closes.

 - Bugfixes for the current release go into scsi-fixes.

 - New features for next release go into scsi-queue.

Consequently, it's perfectly normal for fixes to be more "recent" than
queue. I only rebase the queue if I absolutely have to (i.e. a new
feature depends on something that happened in Linus' tree after the
merge window closed).

-- 
Martin K. Petersen	Oracle Linux Engineering
