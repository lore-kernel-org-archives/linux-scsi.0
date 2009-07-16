From: david@lang.hm
Subject: Re: deterministic scsi order with async scan
Date: Thu, 16 Jul 2009 11:31:13 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0907161128550.9159@asgard>
References: <alpine.DEB.1.10.0907151801040.9159@asgard> <20090716115703.GQ24310@parisc-linux.org> <alpine.DEB.1.10.0907161022540.9159@asgard> <20090716181521.GT24310@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lang.hm ([64.81.33.126]:49145 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZGPSbS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jul 2009 14:31:18 -0400
In-Reply-To: <20090716181521.GT24310@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, 16 Jul 2009, Matthew Wilcox wrote:

> On Thu, Jul 16, 2009 at 10:23:45AM -0700, david@lang.hm wrote:
>> hmm, in that case how can I troubleshoot why this system is detecting the
>> two different PCI-E cards in different orders on different boots.
>
> I don't know.  Are the cards actually being detected in a different
> order, or are the Linux drivers being bound to them in a different order?

I don't know, the end result is that what device is scsi1, scsi2 is 
sometimes different when the machine boots. unfortunantly when they show 
up in the wrong order the system can't find it's boot drive

I guess that the fact that the bios is finding lilo and lilo is finding 
the kernel to try to boot is probably indicating that the hardware is 
being detected in the same order.

> Are you using modules or are these drivers built-in?

built-in
