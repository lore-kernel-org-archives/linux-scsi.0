From: Roland Dreier <rolandd@cisco.com>
Subject: Re: I want scsi_target_block() in interrupt context
Date: Wed, 29 Jun 2005 13:41:37 -0700
Message-ID: <52oe9odhfi.fsf@topspin.com>
References: <52fyv1dqer.fsf@topspin.com>
	<20050629173629.GA32197@infradead.org> <5264vxdp9p.fsf@topspin.com>
	<42C3028C.2020606@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:44966 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S262625AbVF2Ull (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2005 16:41:41 -0400
In-Reply-To: <42C3028C.2020606@cs.wisc.edu> (Mike Christie's message of
 "Wed, 29 Jun 2005 15:20:28 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

    Mike> for iscsi and tcp connections, open-iscsi did the socket
    Mike> connection stuff in userspace then passed the fd down to the
    Mike> driver which used sockfd_lookup().

How does userspace pass the fd down?  Through a character device?

Thanks,
  Roland
