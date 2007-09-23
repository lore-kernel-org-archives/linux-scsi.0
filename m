From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: What's in linux-2.6-block.git for 2.6.24
Date: Sun, 23 Sep 2007 15:11:05 +0100
Message-ID: <20070923151105.5d491df4@the-village.bc.nu>
References: <20070921085711.GG2367@kernel.dk>
	<64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41310 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750756AbXIWOEj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Sep 2007 10:04:39 -0400
In-Reply-To: <64bb37e0709230619v196cf34ev29f0c844e2a79ec9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

> Sep 18 18:50:01 treogen [   63.440000] ata1.00: status: {DRDY }
> Sep 18 18:50:01 treogen [   63.440000] ata1: hard resetting link

Timed out waiting for data transfers to complete that didn't. Does sound
like the device got told the wrong sized transfer.


It then falls off the bus because Jeff hasn't merged Mark Lord's DRQ
draining patch.

Alan
