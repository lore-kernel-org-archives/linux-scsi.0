From: Roland Dreier <rolandd@cisco.com>
Subject: Re: I want scsi_target_block() in interrupt context
Date: Wed, 29 Jun 2005 10:52:18 -0700
Message-ID: <5264vxdp9p.fsf@topspin.com>
References: <52fyv1dqer.fsf@topspin.com>
	<20050629173629.GA32197@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:62519 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S262332AbVF2RwU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2005 13:52:20 -0400
In-Reply-To: <20050629173629.GA32197@infradead.org> (Christoph Hellwig's
 message of "Wed, 29 Jun 2005 18:36:29 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

    Christoph> Just allocate one scsi_host per connection.

OK, that solves the queuing problem nicely.

Right now, I create a scsi_host for each local IB port.  For each
scsi_host, I have a writable sysfs attribute that userspace can put
the addresses of remote ports to connect to.  Any preference for how
to implement the mechanism for userspace to pass in a remote address
to connect to?

Also, with my current scheme, I have a nice hierarchy of devices from
host port to target port to LUN.  Having this topology available seems
nice -- are we losing anything useful for multipathing etc. by not
having a device for the host port?

Thanks,
  Roland
