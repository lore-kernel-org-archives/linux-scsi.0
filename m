From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] aacraid: split off EH functions
Date: Wed, 12 Jul 2017 17:39:44 -0400
Message-ID: <yq1o9spjpwf.fsf@oracle.com>
References: <1498843092-76285-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31438 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752675AbdGLVj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2017 17:39:59 -0400
In-Reply-To: <1498843092-76285-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 30 Jun 2017 19:18:05 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>


Hannes,

> this patchset is a split off from the original patchset to rework SCSI
> EH function parameters. As it's pretty much independent and an
> improvement to the existing EH callback function, so I'm posting it
> separately.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
