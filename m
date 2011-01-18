From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: build failure of drivers/scsi/gdth.c
Date: Tue, 18 Jan 2011 08:46:01 -0800
Message-ID: <20110118084601.ad10d7ac.rdunlap@xenotime.net>
References: <Pine.LNX.4.64.1101121217090.6323@zuben.voltaire.com>
	<20110112083919.494a7404.rdunlap@xenotime.net>
	<AANLkTikmygrH_W=nTB2ERPjUETVNzW=8n7VL9Jf6DLu3@mail.gmail.com>
	<20110113091127.dcdd3105.rdunlap@xenotime.net>
	<4D3543A6.8040909@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:34879 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752265Ab1ARQqH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 11:46:07 -0500
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2011 08:46:02 -0800
In-Reply-To: <4D3543A6.8040909@voltaire.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <ogerlitz@voltaire.com>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org

On Tue, 18 Jan 2011 09:39:18 +0200 Or Gerlitz wrote:

> Randy Dunlap wrote:
> > It builds OK for me.
> 
> okay, maybe something else is broken on my build environment, I'll send
> you off list the compressed verbose build log, the problem I'm not spotting
> is why LINUX_VERSION_CODE is defined to nothing in my env. I'm hitting this
> error on drivers/scsi/gdth.c and some other code that look on that constant,
> luckily there aren't many drivers doing that...

Thanks for more data/details.  There was something similar to this reported
a few months ago, but nothing has been done about it.

What shell are you using?
Are you using any other build scripts that set an variable named VERSION ?


See https://bugzilla.kernel.org/show_bug.cgi?id=16510

An alternative to the current generated version.h file was also suggested:

echo "#define LINUX_VERSION_CODE KERNEL_VERSION($(VERSION), $(PATCHLEVEL),
$(SUBLEVEL))"


HTH.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
