From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for kernel 3.19] Avoid that scsi_device_put() triggers a
 kernel warning
Date: Sun, 18 Jan 2015 07:29:40 -0800
Message-ID: <20150118152940.GB10781@infradead.org>
References: <54AA6F75.7040607@acm.org>
 <20150105130259.GA25960@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbbARP3q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:29:46 -0500
Content-Disposition: inline
In-Reply-To: <20150105130259.GA25960@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, Don Brace <brace77070@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Jan 05, 2015 at 02:02:59PM +0100, Christoph Hellwig wrote:
> I don't like this.  The problem is that sd_shutdown shouldn't even try
> to grab a reference to the scsi device, nevermind the HBA module.

We're fairly late in th 3.19 cycle, and it seems like the proper
fix for the root cause might take a while.  Thus I'm tempte to
add this as the simplest band aid and sort out the root cause
for 3.20.

Does anyone else have a better idea?
