From: Roland Dreier <rolandd@cisco.com>
Subject: Re: I want scsi_target_block() in interrupt context
Date: Wed, 29 Jun 2005 17:01:02 -0700
Message-ID: <52k6kcd875.fsf@topspin.com>
References: <52fyv1dqer.fsf@topspin.com>
	<20050629173629.GA32197@infradead.org> <5264vxdp9p.fsf@topspin.com>
	<42C3028C.2020606@cs.wisc.edu> <52oe9odhfi.fsf@topspin.com>
	<42C30906.5040508@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:62585 "EHLO
	sj-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S262747AbVF3ABG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2005 20:01:06 -0400
In-Reply-To: <42C30906.5040508@cs.wisc.edu> (Mike Christie's message of
 "Wed, 29 Jun 2005 15:48:06 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

    Mike> open-iscsi uses a netlink socket for most of its interface
    Mike> due to how it pushed a lot of code to userspace. You could
    Mike> just do sysfs I bet, or are you having a problem of not
    Mike> having some place to to hang the initial setup attributes.

Yeah, that's the question -- without a scsi_host, what's the natural
place to put an attribute in sysfs?

 - R.
