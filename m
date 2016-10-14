From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Patch: [Open-FCoE] Revert commit 3e22760d4db6fd89e0be46c3d132390a251da9c6 due to performance issues
Date: Fri, 14 Oct 2016 16:39:13 -0400
Message-ID: <yq1bmymk6mm.fsf@sermon.lab.mkp.net>
References: <209207528.804499.1475931430678.JavaMail.zimbra@redhat.com>
        <2d30ad34-7a5e-b2ba-05f4-b0d831944f4c@suse.de>
        <1476197489.4019.68.camel@localhost.localdomain>
        <1476286016.4019.105.camel@localhost.localdomain>
        <000ebf71-9b7a-e6f6-ff8f-0f06eeef64fa@suse.de>
        <1564904000.1465519.1476321625269.JavaMail.zimbra@redhat.com>
        <2049046384.1533310.1476362610308.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48343 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754974AbcJNUjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 16:39:25 -0400
In-Reply-To: <2049046384.1533310.1476362610308.JavaMail.zimbra@redhat.com>
        (Laurence Oberman's message of "Thu, 13 Oct 2016 08:43:30 -0400
        (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Ewan Milne <emilne@redhat.com>, Bud Brown <bubrown@redhat.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "Curtis Taylor (cjt@us.ibm.com)" <cjt@us.ibm.com>, fcoe-devel@open-fcoe.org

>>>>> "Laurence" == Laurence Oberman <loberman@redhat.com> writes:

Laurence> This patch reverts commit
Laurence> 3e22760d4db6fd89e0be46c3d132390a251da9c6.

Laurence> This revert came about because of efforts by Ewan Milne,
Laurence> Curtis Taylor and I.  In researching this issue, significant
Laurence> performance issues were seen on large CPU count systems using
Laurence> the software FCOE stack.  Hannes also weighed in.

Laurence> The same was not apparent on much smaller low count CPU
Laurence> systems.  The behavior introduced by commit
Laurence> 3e22760d4db6fd89e0be46c3d132390a251da9c6 lands sup with large
Laurence> count CPU systems seeing continual blk_requeue_request() calls
Laurence> due to ML_QUEUE_HOST_BUSY.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
