From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] sym2: Use ORDERED_QUEUE_TAG when barrier request is issued
Date: Mon, 13 Feb 2006 13:29:45 -0700
Message-ID: <20060213202945.GL12822@parisc-linux.org>
References: <6.0.0.20.2.20060214004351.0424e5a0@129.60.53.12>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39599 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S964862AbWBMU3r
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2006 15:29:47 -0500
Content-Disposition: inline
In-Reply-To: <6.0.0.20.2.20060214004351.0424e5a0@129.60.53.12>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hifumi Hisashi <hifumi.hisashi@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Tue, Feb 14, 2006 at 01:10:54AM +0900, Hifumi Hisashi wrote:
> I think using ORDERED_QUEUE_TAG is preferable instead of
> SIMPLE_QUEUE_TAG when a request with barrier flag is
> issued.

This isn't enough; we don't know if the target device supports ordered
tags or not.  The right way to do this is to convert sym2 to use the
midlayer tag code.  I think it's nearly at a point where the conversion
is feasible.  I'm going to push out the current set of cleanups next
week and then look at the problem again.
