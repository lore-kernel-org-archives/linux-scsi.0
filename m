From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH 2.4] rewritable USB DVD-RAM vs. mode sense op choice
Date: Mon, 23 Aug 2004 11:24:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <42550282-F529-11D8-BFA2-00039398BB5E@ieee.org>
References: <1092673789.4297.7.camel@patlinux.iomegacorp.com> <2004082315485
	 0.GC2301@suse.de> <F631591B-F523-11D8-BFA2-00039398BB5E@ieee.org> <2004082
	3171253.GD24089@suse.de>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:55785 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S266219AbUHWRYN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 13:24:13 -0400
In-Reply-To: <20040823171253.GD24089@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

>> I believe the specs on the web instead tell us to try MODE_SENSE_10
>> first and then fall back to MODE_SENSE.  I hear you requesting the
>> reverse, I will deliver what I hear you request.
>
> That's what I would do as well, actually. But since this is 2.4 it's
> safe to keep old behaviour and only try something new if that fails.

Clear design goal, thank you.

> Only sr issues 6-byte commands, I don't think support for them was ever
> required for ATAPI devices.
>
> So if you add a
USB
> fallback to issue MODE_SENSE_10 when _6 fails, you
> should be golden.

Clear instruction, will do, thank you.

Ack, ack, ack, we're in sync now, thank you!

Pat LaVarre

