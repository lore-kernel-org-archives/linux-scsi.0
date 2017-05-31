From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] libfc: fix potential timer list corruption
Date: Wed, 31 May 2017 11:27:04 +0200
Message-ID: <46cc3e51-4fcd-8811-a9a8-dac975aef706@suse.de>
References: <1496157254-114166-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36985 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751004AbdEaJ1I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 05:27:08 -0400
In-Reply-To: <1496157254-114166-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org

On 05/30/2017 05:14 PM, Hannes Reinecke wrote:
> Hi all,
> 
> we've seen reports for a crash with an invalid timer_list->function,
> which turned out to be an unsafe usage of libfc discovery callbacks.
> This patchset fixes up the problem
> 
> As usual, comments and reviews are welcome.

The patches look good themselves, but I'd prefer a *why* in the commit
message. For instance in patch 1 you have:

"Move 'pending' and 'requested' setting out of fc_disc_gpn_fc_req()
into the calling function.

No functional change."

But why do you need to move the 'pending' and 'requested' settings?

With an a bit more verbose changelog

Acked-by: Johannes Thumshirn <jth@kernel.org>

for the whole series

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
