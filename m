From: David Miller <davem@davemloft.net>
Subject: Re: qlogicpti driver hangs the machine
Date: Wed, 24 Sep 2008 01:45:53 -0700 (PDT)
Message-ID: <20080924.014553.221132445.davem@davemloft.net>
References: <20080923.212513.184633012.davem@davemloft.net>
	<20080924044211.GL27204@parisc-linux.org>
	<20080923.215302.152506074.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33685
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751452AbYIXIqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 04:46:07 -0400
In-Reply-To: <20080923.215302.152506074.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: mroos@linux.ee, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 23 Sep 2008 21:53:02 -0700 (PDT)

> I'm about to stick a qlogicpti card into my ultra2 and try to reproduce
> this.

Unfortunately, the driver works just fine for me, in fact it's
checking the root filesystem right now :-)

Meelis, if Matthew isn't able to give you some debugging patches or
other stuff to try, I'll try to get this fixed when I get back from
the netfilter workshop in Paris in 2 weeks.
