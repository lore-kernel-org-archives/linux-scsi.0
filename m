From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fixup kernel warning during rmmod()
Date: Fri, 06 Oct 2017 14:49:57 -0400
Message-ID: <yq1lgkonmay.fsf@oracle.com>
References: <1507105736-19148-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28630 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752276AbdJFSuN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2017 14:50:13 -0400
In-Reply-To: <1507105736-19148-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Wed, 4 Oct 2017 10:28:56 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> Calling rmmod() on a FC driver will results in warnings like

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
