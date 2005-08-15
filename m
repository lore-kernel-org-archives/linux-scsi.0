From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.13
Date: Mon, 15 Aug 2005 20:07:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0508152006180.6593@poirot.grange>
References: <1123184634.5026.58.camel@mulgrave>  <Pine.LNX.4.60.0508142121000.4594@poirot.grange>
 <1124048890.18802.13.camel@mulgrave> <Pine.LNX.4.60.0508150811580.5302@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:61668 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S964879AbVHOSJV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 14:09:21 -0400
In-Reply-To: <Pine.LNX.4.60.0508150811580.5302@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 15 Aug 2005, Guennadi Liakhovetski wrote:

> On Sun, 14 Aug 2005, James Bottomley wrote:
> 
> > OK, why don't we do this.  Instead of having me trawl through the trees
> > looking for the correct patch to reverse, why don't you attach it in an
> > email and I'll try to get it in to 2.6.13?
> 
> Looks like just reverting that patch is not enough. More in about 12 
> hours.

Sorry, forget it, just tested here with (pseudo-)highmem on SMP . just 
reverting the patch does indeed fix the driver.

Thanks
Guennadi
---
Guennadi Liakhovetski
