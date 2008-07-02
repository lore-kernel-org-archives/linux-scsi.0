From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Tue, 01 Jul 2008 20:55:00 -0500
Message-ID: <1214963700.3316.41.camel@localhost.localdomain>
References: <877ic8o4iq.fsf@denkblock.local>
	 <87prpxnv4w.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40743 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757484AbYGBBzI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2008 21:55:08 -0400
In-Reply-To: <87prpxnv4w.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-scsi@vger.kernel.org, stable@kernel.org

On Tue, 2008-07-01 at 23:37 +0200, Elias Oltmanns wrote:
> Hi James,
> 
> sorry for bothering you but I've just noticed that the patch below has
> neither been scheduled for the stable review, nor queued up for Linus.
> May be you just don't consider this serious enough for these trees but I
> wanted to make sure that the situation will be dealt with eventualy. The
> patch applies to 2.6.26-rc8.

OK, well at first glance, the locking around device_blocked and
host_blocked looks pointless.  What are the failure traces you're using
to decide they need spinlock protection?

The blk_plug_queue change looks reasonable ... however, blk_plug_queue
itself looks like it might not entirely need the queue lock ... I need
to investigate more closely.

James




