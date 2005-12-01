From: James.Smart@Emulex.Com
Subject: RE: [PATCH 9/11][REPOST #2]  lpfc 8.1.1 : Add polled-mode support
Date: Thu, 1 Dec 2005 13:03:45 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B88@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:27903 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932371AbVLASDy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 13:03:54 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: linux-scsi@vger.kernel.org

> ok fair enough...  what kind of granularity can this delay be set too?
> It might make sense to default to say 50 usec or 100usec always...

Range is in milliseconds, and capped to a value < 100ms.

We had the same thoughts. In general we concluded that the lost cycles in
queuecommand probably still outweighs the gain. This, coupled with the
general hesitancy to change the base behavior w/o a compelling reason,
(and the qual impacts) means we have no desire to change the default.
 
> Also, not sure how your hardware works but it would be really sweet if
> the kernel could set "this request should be coalesed" or 
> "this request
> is latency sensitive, gimme immediate", so that we can set async write
> IO's for coalescing while not getting latency on reads...

Yep. Unfortunately, nothing this granular.

-- james
