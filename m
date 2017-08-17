From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3 0/6] hpsa legacy support
Date: Wed, 16 Aug 2017 20:22:14 -0400
Message-ID: <yq17ey3qc09.fsf@oracle.com>
References: <1502780289-127133-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34425 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdHQAWe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 20:22:34 -0400
In-Reply-To: <1502780289-127133-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 15 Aug 2017 08:58:03 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org


Hannes,

> here's now the third attempt to add support for legacy boards, ie for
> boards previously supported by cciss only.  With this patchset the
> hpsa driver should work with all Smart Array boards if the
> 'hpsa_allow_any' module option is set, rendering the cciss driver
> obsolete.  Consequently I've added a patch to remove the cciss driver
> and make 'hpsa' an alias to 'cciss' and removed the 'hpsa_allow_any'
> module option.

Applied to 4.14/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
