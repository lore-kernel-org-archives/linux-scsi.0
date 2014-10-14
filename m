From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Concurrent SG_SCSI_RESET ioctls
Date: Tue, 14 Oct 2014 04:13:54 -0700
Message-ID: <20141014111354.GA3022@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
 <20141011161110.GA16812@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958CEB20A@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaJNLN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2014 07:13:57 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CEB20A@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

On Sat, Oct 11, 2014 at 10:06:47PM +0000, Elliott, Robert (Server Storage) wrote:
> Thanks.  That's a bit better, but sg_reset can now run into
> "No such device" errors.

That's the -ENODEV we return if another reset is in progress.  Given
that I suspect sg_reset is the prime if not only user of this interface
I'm happy to change the error code we return here to anything Doug
agrees to.

