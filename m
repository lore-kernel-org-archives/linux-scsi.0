From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: eata fails to load on post 4.2 kernels
Date: Thu, 10 Sep 2015 18:30:18 +0930
Message-ID: <55F146A2.7020103@internode.on.net>
References: <v03tbc-ufe.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net> <55EC019F.4010209@internode.on.net> <55EC2567.8000100@internode.on.net> <55ECA291.1060103@internode.on.net> <55ECFF32.9030902@linux.intel.com> <55ED2DFA.6030502@internode.on.net> <55EE6FD1.2030600@linux.intel.com> <55F13644.2080203@internode.on.net> <55F13B9A.4090101@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:41496 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbbIJJAY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2015 05:00:24 -0400
In-Reply-To: <55F13B9A.4090101@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, tglx@linutronix.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



Jiang Liu wrote on 10/09/15 17:43:
> Hi Authur,
> 	Thanks for the updating. Seem Bjorn doesn't like
> neither of my two patches. So I'm trying to convert eata
> to formal PCI driver, but the change will be much more
> bigger and still not sure whether we could achieve that.
> Will keep you updated.
> Thanks!
> Gerry

Thanks, I'm a bit concerned since the original

commit 991de2e59090e55c65a7f59a049142e3c480f7bd

broke things badly for me (requiring irqpoll to avoid a kernel hang) and 
neither of the patches enabled kexec reboots to work like before the 
original commit.

I just tested a kexec reboot with irqpoll enabled and that continues to 
fail, so I'm back to running 4.2 kernel until there is a patch that 
works with kexec reboots.

Arthur.
