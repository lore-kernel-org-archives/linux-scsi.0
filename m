From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH v3] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Wed, 04 Jan 2017 10:38:52 -0500
Message-ID: <1483544332.15161.30.camel@localhost.localdomain>
References: <1481509217-23567-1-git-send-email-fangwei1@huawei.com>
         <1481559825.4643.2.camel@localhost.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933266AbdADPiy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Jan 2017 10:38:54 -0500
In-Reply-To: <1481559825.4643.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com, chenzengxi@huawei.com

On Mon, 2016-12-12 at 11:23 -0500, Ewan D. Milne wrote:
> ...I have not heard back yet
> from the site that reported this problem to me on their reproducer.

Not that it matters much now, but..

The response from my original reporter is that indeed the state was
being changed from SDEV_BLOCK -> SDEV_RUNNING in scsi_sysfs_add_sdev()
so the fix is correct.

-Ewan


