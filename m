From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] libsas: Disable asynchronous aborts for SATA devices
Date: Wed, 10 Jan 2018 16:40:10 -0500
Message-ID: <yq1tvvtv1dx.fsf@oracle.com>
References: <1515512632-115483-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50352 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbeAJVka (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 16:40:30 -0500
In-Reply-To: <1515512632-115483-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 9 Jan 2018 16:43:52 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>, Hannes Reinecke <hare@suse.com>


Hannes,

> Handling CD-ROM devices from libsas is decidedly odd, as libata relies
> on SCSI EH to be started to figure out that no medium is present.  So
> we cannot do asynchronous aborts for SATA devices.

Applied to 4.15/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
