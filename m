From: David Miller <davem@davemloft.net>
Subject: Re: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 15:29:10 -0700 (PDT)
Message-ID: <20070416.152910.107940079.davem@davemloft.net>
References: <20070416211049.GC13590@andrew-vasquezs-computer.local>
	<20070416.150846.45744461.davem@davemloft.net>
	<20070416222517.GD14351@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51710
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbXDPW3I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Apr 2007 18:29:08 -0400
In-Reply-To: <20070416222517.GD14351@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Mon, 16 Apr 2007 15:25:17 -0700

> Fine, I'll agree that wacking-users (and
> I'll wager the outliers) with a 2x4 was a bit extreme,

And that, right there, is basically the end of the conversation.

You don't do this to users, ever.

Put a big loud kernel log message in there when this situation
presents itself, use as many capital letters and scary language that
you wish.  Let them know that if things explode they get to keep the
pieces.

But at least try to give them something that works when you know that
you can.

You don't need to make someone's system unbootable in order to make
them aware of a potential problem.  It's very anti-social to approach
things in this way.
