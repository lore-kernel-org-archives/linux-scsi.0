From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: might_sleep warnings in gereric_make_request
Date: Wed, 19 Apr 2006 21:31:08 -0600
Message-ID: <20060420033108.GO24104@parisc-linux.org>
References: <200604201105448287687@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37263 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751168AbWDTDbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 23:31:09 -0400
Content-Disposition: inline
In-Reply-To: <200604201105448287687@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhikun Wang <raidwang@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Eric Moore <Eric.Moore@lsil.com>

On Thu, Apr 20, 2006 at 11:05:55AM +0800, Zhikun Wang wrote:
> Hi:
> 	I want to call genric_make_request in bio->bi_end_io function. But it incurs might_sleep warnings! I wonder this method is safe in the kernel? Thanks a lot! 
> 
> 
> cfq: depth 4 reached, tagging now on
> Debug: sleeping function called from invalid context at drivers/block/ll_rw_blk.c:2878
> in_atomic():1, irqs_disabled():0

You can't call generic_make_request() from interrupt context.  What are
you trying to do?
