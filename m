From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 30 Mar 2005 16:13:21 -0600
Message-ID: <1112220802.9435.1.camel@mulgrave>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
	 <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>
	 <20050321104419.GH23911@suse.de>
	 <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
	 <Pine.LNX.4.60.0503302318250.9431@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:63120 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262451AbVC3WNr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 17:13:47 -0500
In-Reply-To: <Pine.LNX.4.60.0503302318250.9431@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: gl@dsa-ac.de, Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-03-30 at 23:22 +0200, Guennadi Liakhovetski wrote:
> What is going to happen to this stuff? The current Linus' tree contains a 
> broken (by me:-() dc395x, other drivers (including tmscsim) would benefit 
> from a generic API. I understand, the drivers are not top importance, but 
> still.

I'd propose fixing the driver first and then using that fix as the basis
for a generic API.  Is the patch you sent on the 17th of March what
you'd consider to be your final fix for this?

James


