From: Christoph Hellwig <hch@infradead.org>
Subject: Re: I/O path cleanup
Date: Tue, 30 Sep 2014 06:43:53 -0700
Message-ID: <20140930134353.GA26479@infradead.org>
References: <1410107469-896-1-git-send-email-hch@lst.de>
 <540D5940.8070900@acm.org>
 <20140908151301.GA2551@lst.de>
 <542AB0AD.1090604@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaI3Nny (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 09:43:54 -0400
Content-Disposition: inline
In-Reply-To: <542AB0AD.1090604@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Webb Scales <webbnh@hp.com>, Ewan Milne <emilne@redhat.com>

On Tue, Sep 30, 2014 at 03:31:25PM +0200, Bart Van Assche wrote:
> At least in the tests I ran myself these patches are working fine in
> combination with scsi-mq and the SRP initiator. The tree I have been testing
> with has commit ID ec8af1eb08f2 - this is the tree on top of v3.17-rc4.

Thanks.  Can you give me formal Reviewed-by: and Tested-by: tags for the
patches?

Also any chance someone in the Cc list can give me a second review so
that I can merge it into the core-for-3.18 tree?
