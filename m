From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2 0/3] fcoe: fixup device_del() inversion
Date: Fri, 15 Sep 2017 15:45:54 -0400
Message-ID: <yq1vakjoidp.fsf@oracle.com>
References: <1505473934-123915-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42406 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdIOTqD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 15:46:03 -0400
In-Reply-To: <1505473934-123915-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 15 Sep 2017 13:12:11 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org


Hannes,

> when shutting down an FCoE target system one is greeted with a flood
> of kernel warnings about

Applied to 4.15/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
