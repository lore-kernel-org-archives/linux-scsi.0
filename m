From: Christoph Hellwig <hch@infradead.org>
Subject: Re: blk-mq vs kmemleak
Date: Mon, 3 Aug 2015 06:33:27 -0700
Message-ID: <20150803133327.GA3390@infradead.org>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
 <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
 <559BDB49.70209@sandisk.com>
 <20150708081740.GA3374@infradead.org>
 <55BC14AE.3090200@sandisk.com>
 <20150803104309.GB4033@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbbHCNdc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 09:33:32 -0400
Content-Disposition: inline
In-Reply-To: <20150803104309.GB4033@e104818-lin.cambridge.arm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@codemonkey.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Aug 03, 2015 at 11:43:09AM +0100, Catalin Marinas wrote:
> The simplest would be to add a kmemleak_not_leak() annotation in
> scsi_init_request(), though you would hide real leaks (if any).
> 
> A better way could be to inform kmemleak of these pages, something like
> below (compile-tested only):

Both versions sound reasonable to me, but I'd prefer the second one if
it works.
