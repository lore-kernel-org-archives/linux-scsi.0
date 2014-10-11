From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Concurrent SG_SCSI_RESET ioctls
Date: Sat, 11 Oct 2014 09:11:10 -0700
Message-ID: <20141011161110.GA16812@infradead.org>
References: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJKQLW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Oct 2014 12:11:22 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958CE9B54@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Don Brace (PMC)" <Don.Brace@pmcs.com>, "Scales, Webb" <webb.scales@hp.com>

Hi Robert,

can you take a look at the patches at:

http://git.infradead.org/users/hch/scsi.git/shortlog/refs/heads/scsi-ioctl

and confirm if they fix your issue?

