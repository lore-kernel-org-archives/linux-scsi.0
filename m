From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] dpt_i2o: don't set DMA_64BIT_MASK [was: Re: [stable]
	broken dpt_i2o in 2.6.23 (was: ext2 check page: bad entry in directory)
	(fwd)]
Date: Thu, 13 Dec 2007 07:58:01 -0500
Message-ID: <1197550681.3154.7.camel@localhost.localdomain>
References: <20071212105841.GN6770@1und1.de>
	 <20071212033808.6fb92139.akpm@linux-foundation.org>
	 <1197464879.20796.15.camel@n2o.xs4all.nl> <20071212134342.GR6770@1und1.de>
	 <20071212111629.9a4f7f73.akpm@linux-foundation.org>
	 <1197489294.4203.40.camel@localhost.localdomain>
	 <20071212221627.GA16474@kroah.com>  <20071213101144.GA61767@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:33792
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbXLMM6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 07:58:12 -0500
In-Reply-To: <20071213101144.GA61767@xs4all.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, matthew@wil.cx, linux-kernel@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Anders Henke <anders.henke@1und1.de>, stable@kernel.org


On Thu, 2007-12-13 at 11:11 +0100, Miquel van Smoorenburg wrote:
> According to Greg KH:
> > So, what should be added to 2.6.23-stable then?  And, can I get a real
> > changelog entry for it?
> 
> This is suitable for both 2.6.23.x and 2.6.24-rc5 :
> 
> linux-2.6-dpt_i2o-no-dma64.patch

Actually, this one's already queued:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=a066b307861238c1970310579c0bc2fe8c8dca51

James


