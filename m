From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sun, 21 Aug 2005 18:07:30 +0100
Message-ID: <20050821170730.GA28572@infradead.org>
References: <20050819140631.GB12485@lst.de> <43061C3C.2020303@adaptec.com> <20050819175459.GA16619@lst.de> <43061D57.9060201@adaptec.com> <20050819175929.GA5614@infradead.org> <43061FC9.8060301@adaptec.com> <1124481582.5130.88.camel@mulgrave> <430641CF.3070709@adaptec.com> <20050820091814.GB21698@infradead.org> <430769B9.9080302@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:38093 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751157AbVHUVlN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 17:41:13 -0400
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by zeus1.kernel.org (8.13.1/8.13.1) with ESMTP id j7LHB2oE006987
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 10:11:02 -0700
Content-Disposition: inline
In-Reply-To: <430769B9.9080302@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Aug 20, 2005 at 01:34:49PM -0400, Luben Tuikov wrote:
> > that even if my minimal code goes in now there's absolutely no reason
> > we can't replace it completely later on.  See the evolution of the FC
> > transport class.
> 
> Who makes all those decisions?

In the end James, unless he'd be over-ruled by Linus (which is rather unlikely)

> More generally, why is SCSI Core not being managed by
> Documentation/ManagingStyle?

It is.

> Is it because there's so much vendor interest here?

There's about as much vendor interest as elsewhere.

