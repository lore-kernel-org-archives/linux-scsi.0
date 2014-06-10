From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Open-FCoE] [PATCH] fc: ensure scan_work isn't active when
 freeing fc_rport
Date: Tue, 10 Jun 2014 04:38:41 -0700
Message-ID: <20140610113841.GC26195@infradead.org>
References: <1401461974-7879-1-git-send-email-nhorman@tuxdriver.com>
 <1401751370.5752.5.camel@vi-devel>
 <20140606205409.GD2543@hmsreliant.think-freely.org>
 <1402337383.5752.153.camel@vi-devel>
 <20140609191637.GA3535@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36168 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFJLiu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 07:38:50 -0400
Content-Disposition: inline
In-Reply-To: <20140609191637.GA3535@hmsreliant.think-freely.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Vasu Dev <vasu.dev@linux.intel.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, james.smart@emulex.com, hch@infradead.org

On Mon, Jun 09, 2014 at 03:16:37PM -0400, Neil Horman wrote:
> > Given fcoe is quite mature now and its patches volume is very low, so
> > getting its kernel patches directly to scsi subsystem should work fine
> > and should be okay with James or Christophs to pull into scsi subsystem
> > directly once I've my non-author signoff ACK there as described in this
> > announcement at http://marc.info/?l=linux-scsi&m=140050839729415&w=2 
> > 
> > If no alternate suggestion or objection to this then I'll formally
> > announce this on fcoe mailing list.
> > 
> > However for any huges patches series bomb or RFCs, I'll request fcoe
> > developers to send patches against scsi tree at fcoe devel list first
> > and then if needed I can roll them up.
> > 
> > Thanks,
> > Vasu
> > 
> Copy that Vasu, Christoph, is that ok with you?

That's fine with me.  It would help greatly if you could make sure
all the paches get a review or two very quickly so I can just pick them
up immediately after reviewing them.

