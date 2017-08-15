From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2 0/6] hpsa legacy support
Date: Mon, 14 Aug 2017 23:39:19 -0400
Message-ID: <yq14lt9wlco.fsf@oracle.com>
References: <1502709555-15837-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36478 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753097AbdHODjl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2017 23:39:41 -0400
In-Reply-To: <1502709555-15837-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Mon, 14 Aug 2017 13:19:09 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org


Hannes,

> here's now the second attempt to add support for legacy boards, ie for
> boards previously supported by cciss only.  With this patchset the
> hpsa driver should work with all Smart Array boards if the
> 'hpsa_allow_any' module option is set, rendering the cciss driver
> obsolete.  Consequently I've added a patch to remove the cciss driver
> and make 'hpsa' an alias to 'cciss'.

How does the module alias solve the problem that hpsa_allow_any=1 needs
to be added for users currently running cciss?

I also fail to see what the point is of having an opt-in parameter when
there is no alternative after cciss has been removed. It's a
don't-be-broken switch.

-- 
Martin K. Petersen	Oracle Linux Engineering
