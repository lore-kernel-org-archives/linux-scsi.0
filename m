From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [Linux-usb-users] Possible bug in usb storage (2.6.11 kernel)
Date: Thu, 29 Sep 2005 01:27:05 +0900 (JST)
Message-ID: <20050929.012705.37532453.anemo@mba.ocn.ne.jp>
References: <20050927.234616.36922370.anemo@mba.ocn.ne.jp>
	<Pine.LNX.4.44L0.0509271120370.5703-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mba.ocn.ne.jp ([210.190.142.172]:49872 "EHLO smtp.mba.ocn.ne.jp")
	by vger.kernel.org with ESMTP id S1751341AbVI1Q22 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2005 12:28:28 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509271120370.5703-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: jim.ramsay@gmail.com, mdharm-kernel@one-eyed-alien.net, ralf@linux-mips.org, linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

>>>>> On Tue, 27 Sep 2005 11:38:35 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> said:

stern> If that is so, it's a bug in linux-mips.  ARCH_KMALLOC_MINALIGN
stern> is supposed to be at least as large as a cacheline.  See this
stern> comment in mm/slab.c:

Thank you for pointing out this.

Some time ago I also supposed so, but I was told to use
dma_get_cache_alignment() instead.  The comment was not exist at that
time...

OK, I will talk to MIPS maintainar again.
---
Atsushi Nemoto
