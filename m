From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] [SCSI] gdth: misc cleanups, preparation for
	ISA/EISA hotplug API
Date: Sun, 24 Feb 2008 00:31:17 -0500
Message-ID: <20080224053117.GA13904@infradead.org>
References: <017ac0b5a1e36b990eedfb7124c78d58f947f076.1203828195.git.jeff@garzik.org> <20080224045810.GA17051@infradead.org> <47C0FE1F.300@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYBXFbS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 00:31:18 -0500
Content-Disposition: inline
In-Reply-To: <47C0FE1F.300@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 12:18:23AM -0500, Jeff Garzik wrote:
> hmmmmm.  We'll see how it plays out...  on the remove side, the above is 
> exact what happens in gdth_remove_one() without my patch, thus 
> consolidating two cases of the same code into one.  There is a less-strong 
> argument for doing the allocation that way, but it may turn out to be 
> useful anyway once the ISA/EISA API conversion is complete.

EISA ->remove has a different prototype from PCI ->remove from ISA
->remove, so gdth_remove_one will be split up eventually.  Having the
scsi_host_put duplicated in each shouldn't be too much of a problem :)

