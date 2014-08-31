From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/22] scsi: use local buffer for printing the opcode
Date: Sun, 31 Aug 2014 15:19:46 -0700
Message-ID: <20140831221946.GI16432@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaHaWTs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Aug 2014 18:19:48 -0400
Content-Disposition: inline
In-Reply-To: <1409247216-76074-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On Thu, Aug 28, 2014 at 07:33:27PM +0200, Hannes Reinecke wrote:
> SCSI opcode printing is tricky and needs to take into account
> several different corner cases. So instead of trying to come
> up with an elaborate printk() statement we should be printing
> it into a local buffer.

scsi_print_command callers are usually deep down the call chain., so I'd
rather avoid using up even more stack here.  What are the exact reasons
that we need the local buffer?

