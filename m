From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: I want scsi_target_block() in interrupt context
Date: Wed, 29 Jun 2005 15:48:06 -0500
Message-ID: <42C30906.5040508@cs.wisc.edu>
References: <52fyv1dqer.fsf@topspin.com>	<20050629173629.GA32197@infradead.org> <5264vxdp9p.fsf@topspin.com>	<42C3028C.2020606@cs.wisc.edu> <52oe9odhfi.fsf@topspin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:14232 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262619AbVF2UsX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2005 16:48:23 -0400
In-Reply-To: <52oe9odhfi.fsf@topspin.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rolandd@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Roland Dreier wrote:
>     Mike> for iscsi and tcp connections, open-iscsi did the socket
>     Mike> connection stuff in userspace then passed the fd down to the
>     Mike> driver which used sockfd_lookup().
> 
> How does userspace pass the fd down?  Through a character device?
> 

open-iscsi uses a netlink socket for most of its interface due to how it 
pushed a lot of code to userspace. You could just do sysfs I bet, or are 
you having a problem of not having some place to to hang the initial 
setup attributes.
