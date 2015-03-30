From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 00/22] target: se_node_acl LUN list RCU conversion
Date: Mon, 30 Mar 2015 12:21:30 -0700
Message-ID: <20150330192130.GA27541@infradead.org>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
 <20150330120823.GA20193@infradead.org>
 <5519A0F4.4020102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbbC3TVd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2015 15:21:33 -0400
Content-Disposition: inline
In-Reply-To: <5519A0F4.4020102@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On Mon, Mar 30, 2015 at 12:16:04PM -0700, Andy Grover wrote:
> I dug my patches up and rebased on top of target-pending/for-next. Pushed
> here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/grover/linux.git
> mar30-dynalloc-deve
> 
> https://git.kernel.org/cgit/linux/kernel/git/grover/linux.git/log/?h=mar30-dynalloc-deve
> 
> if this is helpful for your efforts.

See the branch above, it does everything your old series did except
for dynamic allocation of the LUNs, although it gets there through a
different way.
