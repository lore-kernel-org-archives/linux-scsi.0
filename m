From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: init / exit cleanup
Date: Sun, 6 Jun 2004 18:09:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606170926.GA10396@infradead.org>
References: <20040603133835.GA16378@infradead.org> <Pine.LNX.4.44.0406032213080.4721-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:61635 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263827AbUFFRJ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jun 2004 13:09:28 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0406032213080.4721-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Thu, Jun 03, 2004 at 10:23:45PM +0200, Guennadi Liakhovetski wrote:
> Sorry, do you have a reference or remember at least apporoximatly when and
> where the discussion took place?

Sorry, don't remember anymore.  Try searching the lkml archives.

>  I don't quite understand your arguments.
> We do have __dev{init,exit,...} macros, do they have "problems over the
> module boundary"? If yes - they want to be solved, right?

currently you can have pointers to __devinitdata functions in structures
registered with other modules.  Having more different lifetime rules will
complicate that enormously and need a audit of the whole kernel first.

