From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Mon, 2 Jun 2014 00:58:12 -0700
Message-ID: <20140602075812.GA29632@infradead.org>
References: <20140519140614.GA12183@infradead.org>
 <20140520100343.31490551@canb.auug.org.au>
 <20140520053928.GA1751@infradead.org>
 <20140521094636.515289e8@canb.auug.org.au>
 <1400639101.2481.19.camel@dabdike>
 <20140528105429.GA20549@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56200 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaFBH6N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 03:58:13 -0400
Content-Disposition: inline
In-Reply-To: <20140528105429.GA20549@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

With Linus opening the merge window things should calm down now.

I've pushed the mvsas pciid update, and a revert of the be2scsi patch
that wasn't quite ready to the drivers-for-3.16 branch.

I've also created a new drivers-for-3.16-2 branch that contains the
remaining hpsa updates that might be too big for Linus taste that late
but should probably be fine.  I also expect to add the relatively small
lpfc update to it once I get second review in proper form.

