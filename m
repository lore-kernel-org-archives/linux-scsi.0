From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] scsi: serialize ->rescan against ->remove
Date: Mon, 2 Feb 2015 13:59:35 +0100
Message-ID: <20150202125935.GA16046@lst.de>
References: <1422486056-11591-1-git-send-email-hch@lst.de> <54CABE29.5080909@redhat.com> <20150130010849.GA4794@ad.nay.redhat.com> <54CB52E9.6000302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43985 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933064AbbBBM7j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2015 07:59:39 -0500
Content-Disposition: inline
In-Reply-To: <54CB52E9.6000302@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Fam Zheng <famz@redhat.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

On Fri, Jan 30, 2015 at 10:46:17AM +0100, Paolo Bonzini wrote:
> Great, we might want to revert that patch in 3.21.

Is that fix in any tree yet?  Seems like I missed it for the scsi
tree at least.  So unless you want it for 3.19/stable we might as well
ust skip that patch.
