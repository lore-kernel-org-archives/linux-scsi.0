From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] scsi_transport_fc: FC timeout handler
Date: Sat, 25 May 2013 11:38:55 +0200
Message-ID: <51A086AF.5050609@suse.de>
References: <1369389050-118628-1-git-send-email-hare@suse.de> <1369389050-118628-5-git-send-email-hare@suse.de> <20130525050842.GA6973@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab3EYIjE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 May 2013 04:39:04 -0400
In-Reply-To: <20130525050842.GA6973@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>

On 05/25/2013 07:08 AM, Christoph Hellwig wrote:
> This looks like a good start, but why would we make this FC specific?
>
Because James B. said so :-)

No, seriously:
You would need to revisit the good old SCSI parallel LLDDs to figure out 
if this approach works for them.
Eg aic7xxx basically has to stop the entire HBA even for an abort as it 
has to look through its internal queues etc to locate the command.
So for them it wouldn't make much difference.
Plus no-one has the knowledge nor the equipment to check _all_ SPI LLDDs 
to ensure this will work for them.

Cheers,

Hannes

