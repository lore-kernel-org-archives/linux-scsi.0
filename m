From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: I want scsi_target_block() in interrupt context
Date: Thu, 30 Jun 2005 19:24:18 -0500
Message-ID: <42C48D32.4040308@cs.wisc.edu>
References: <52fyv1dqer.fsf@topspin.com>	<20050629173629.GA32197@infradead.org> <5264vxdp9p.fsf@topspin.com>	<42C3028C.2020606@cs.wisc.edu> <52oe9odhfi.fsf@topspin.com>	<42C30906.5040508@cs.wisc.edu> <52k6kcd875.fsf@topspin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:26525 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S263142AbVGAAZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2005 20:25:31 -0400
In-Reply-To: <52k6kcd875.fsf@topspin.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rolandd@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Roland Dreier wrote:
>     Mike> open-iscsi uses a netlink socket for most of its interface
>     Mike> due to how it pushed a lot of code to userspace. You could
>     Mike> just do sysfs I bet, or are you having a problem of not
>     Mike> having some place to to hang the initial setup attributes.
> 
> Yeah, that's the question -- without a scsi_host, what's the natural
> place to put an attribute in sysfs?
> 

Don't know. For iscsi-sfnet we tried puttting it a lot of difference 
places: our own class, made a virtual driver model bus, on our 
/sys/module dir. configfs ended up working ok.
