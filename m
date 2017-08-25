From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ses: Fix racy cleanup of /sys in remove_dev()
Date: Fri, 25 Aug 2017 17:36:25 -0400
Message-ID: <yq1shgf5nza.fsf@oracle.com>
References: <1503580432-105307-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51556 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755288AbdHYVgh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 17:36:37 -0400
In-Reply-To: <1503580432-105307-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Thu, 24 Aug 2017 15:13:52 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Calvin Owens <calvinowens@fb.com>


Hannes,

> Currently we free the resources backing the enclosure device before we
> call device_unregister(). This is racy: during rmmod of low-level SCSI
> drivers that hook into enclosure, we end up with a small window of
> time during which writing to /sys can OOPS. Example trace with
> mpt3sas:

Applied to 4.14/scsi-queue but dropped link to non-public bugzilla.

-- 
Martin K. Petersen	Oracle Linux Engineering
