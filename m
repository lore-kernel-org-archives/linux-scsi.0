From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mptsas: Fixup device hotplug for VMWare ESXi
Date: Fri, 25 Aug 2017 17:33:21 -0400
Message-ID: <yq1wp5r5o4e.fsf@oracle.com>
References: <1503579163-104386-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50684 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932374AbdHYVde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 17:33:34 -0400
In-Reply-To: <1503579163-104386-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Thu, 24 Aug 2017 14:52:43 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> VMWare ESXi emulates an mptsas HBA, but exposes all drives as
> direct-attached SAS drives.  This it not how the driver originally
> envisioned things; SAS drives were supposed to be connected via an
> expander, and only SATA drives would be direct attached.  As such any
> hotplug event for direct-attach SAS drives was silently ignored, and
> the guest failed to detect new drives from within a VMWare ESXi
> environment.

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
