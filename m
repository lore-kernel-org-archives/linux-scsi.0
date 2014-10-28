From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] ipr: Disable async aborts
Date: Tue, 28 Oct 2014 01:47:16 -0700
Message-ID: <20141028084716.GA14286@infradead.org>
References: <201410271439.s9REdl9U017474@d01av02.pok.ibm.com>
 <1414421403.6401.5.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaJ1IrR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Oct 2014 04:47:17 -0400
Content-Disposition: inline
In-Reply-To: <1414421403.6401.5.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

On Mon, Oct 27, 2014 at 07:50:03AM -0700, James Bottomley wrote:
> On Mon, 2014-10-27 at 09:37 -0500, Brian King wrote:
> > The ipr driver does not yet support async aborts, so disable this
> > for now.
> > 
> > Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> 
> By "does not yet support" do you mean doesn't work with or merely not
> tested with but seems to work OK?  if the former, then surely this
> should be a fixes patch with a cc to stable for all the kernels async
> abort is in (which is 3.14)

I'm pretty sure this patch is incorrect, and that what ever issue should
have been described in this patch are the same EH problems we fixed in
the last couple releases.  I've also talked to Hannes a while ago, and
we agree that we want to remove this flag ASAP as it's inviting this
