From: gl@dsa-ac.de
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Thu, 31 Mar 2005 10:58:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.56.0503311051290.20956@pcgl.dsa-ac.de>
References: <20050321075531.GC23911@suse.de> <7044.1111398919@www16.gmx.net>
  <Pine.LNX.4.56.0503211111290.20956@pcgl.dsa-ac.de>  <20050321104419.GH23911@suse.de>
  <Pine.LNX.4.56.0503211147420.20956@pcgl.dsa-ac.de>
 <Pine.LNX.4.60.0503302318250.9431@poirot.grange> <1112220802.9435.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dsa-ac.de ([62.112.80.99]:7692 "EHLO mail.dsa-ac.de")
	by vger.kernel.org with ESMTP id S261200AbVCaJB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 04:01:57 -0500
In-Reply-To: <1112220802.9435.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 30 Mar 2005, James Bottomley wrote:

> On Wed, 2005-03-30 at 23:22 +0200, Guennadi Liakhovetski wrote:
> > What is going to happen to this stuff? The current Linus' tree contains a
> > broken (by me:-() dc395x, other drivers (including tmscsim) would benefit
> > from a generic API. I understand, the drivers are not top importance, but
> > still.
>
> I'd propose fixing the driver first and then using that fix as the basis
> for a generic API.  Is the patch you sent on the 17th of March what
> you'd consider to be your final fix for this?

Well, it could be. But I'd use Jens' suggestion and actually test it for
highmem. And, since we are at it, I'd try to organise this code in
separate API, so, that we just have to replace dc395x_* with scsi_* in
function names. Makes sense?

Thanks
Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany
