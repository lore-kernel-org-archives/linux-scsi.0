From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: restart list search after unlock in
	scsi_remove_target
Date: Mon, 19 Oct 2015 17:56:58 +0200
Message-ID: <20151019155658.GA11453@lst.de>
References: <20151019143546.GA7486@lst.de> <56250DF7.6050803@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54242 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbbJSP5A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 11:57:00 -0400
Content-Disposition: inline
In-Reply-To: <56250DF7.6050803@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, jthumshirn@suse.de, Dan Williams <dan.j.williams@intel.com>

On Mon, Oct 19, 2015 at 08:36:23AM -0700, Bart Van Assche wrote:
> Thanks for looking into this. However, I think we need a motivation in the 
> patch description why this patch does not reintroduce the soft lockup 
> documented in patch "scsi_remove_target: fix softlockup regression on hot 
> remove" (commit bc3f02a795d3).

Interesting.  I tried to find the original report and what state
changes would cause an endless loop here.  Dan, do you remember any
details about this bug report?
