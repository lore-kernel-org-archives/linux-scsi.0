From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND] [SCSI] bfa: Fix undefined bit shift on big-endian
 architectures with 32-bit DMA address
Date: Wed, 25 Jun 2014 13:12:24 +0200
Message-ID: <20140625111224.GA19415@infradead.org>
References: <1402266805.23860.40.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57898 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaFYLKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 07:10:08 -0400
Content-Disposition: inline
In-Reply-To: <1402266805.23860.40.camel@deadeye.wl.decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can I get another review, too please?

