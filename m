From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] libosd: write/read_sg_kern API
Date: Mon, 1 Nov 2010 12:13:29 -0400
Message-ID: <20101101161329.GA24836@infradead.org>
References: <4CBD8CAB.2030207@panasas.com>
 <1287490962-24013-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330Ab0KAQNh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 12:13:37 -0400
Content-Disposition: inline
In-Reply-To: <1287490962-24013-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Oct 19, 2010 at 02:22:42PM +0200, Boaz Harrosh wrote:
> From: John A. Chandy <john.chandy@uconn.edu>
> 
> This is a trivial addition to the SG API that can receive kernel
> pointers. It is only used by the out-of-tree test module. So
> it's immediate need is questionable. For maintenance ease it might
> just get in, as it's very small.
> 
> John.
> do you need this in the Kernel, or is it only for osd_ktest.ko?

It really shouldn't be in the tree at all. s/g lists are not something
that should be passed to a logical I/O layer.

