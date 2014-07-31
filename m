From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -next] scsi: fix u14-34f printk format warnings
Date: Thu, 31 Jul 2014 10:29:41 -0700
Message-ID: <20140731172941.GA23891@infradead.org>
References: <53D14B7E.7000602@infradead.org>
 <53DA6E25.4090409@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGaR3n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2014 13:29:43 -0400
Content-Disposition: inline
In-Reply-To: <53DA6E25.4090409@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dario Ballabio <ballabio_dario@emc.com>

Thanks, Randy.

I'll merge it.  I usually want a second review for scsi patches, but I
guess this one is trivial enough to waive that requirement.

That being said is anyone still using the u14-34f driver?  From looking
at the commit history it doesn't really look either maintained or used..

