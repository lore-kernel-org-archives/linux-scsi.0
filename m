From: Christoph Hellwig <hch@lst.de>
Subject: Re: please revert [PATCH] s390: zfcp act enhancements
Date: Wed, 17 Nov 2004 15:54:44 +0100
Message-ID: <20041117145444.GA26717@lst.de>
References: <20041116010130.771b4619.akpm@osdl.org> <OFE1CCC05C.0690AC49-ON42256F4E.0032BD42-42256F4E.00354C44@uk.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:56809 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262335AbUKQOyz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 09:54:55 -0500
Content-Disposition: inline
In-Reply-To: <OFE1CCC05C.0690AC49-ON42256F4E.0032BD42-42256F4E.00354C44@uk.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, BOEBLINGEN LINUX390 <linux390@de.ibm.com>, linux-scsi@vger.kernel.org

> I talked with the scsi people about the exports. And yes, the intent for
> adding these exports has been to allow the hba abi in its current form to
> work with a single add-on module. We know that this is a dead-end path but
> they (our scsi folks) want to have a working solution now.

That's not how Linux works.  LLDDs are not supposed to add APIs,
especially not that bad ones.

> The standard
> answer to that usually is that the real solution takes as long as it takes.
> We find ourselves in between these two positions. Not a good place to be.
> 
> > > If IBM wants to support a managment API for their FC adapter they should
> > > participate in the FC transport class development.
> > >
> > > I also want to protest that IBM sends scsi LLDD updates not via
> > > linux-scsi *AGAIN*.
> 
> Mea culpa, this has been my fault. This addresses a question that bothers
> me for some time: should zfcp updates go over the arch line to -bk or would
> it be better to push ALL zfcp updates via linux-scsi and the scsi maintainers.
> I don't really understand in detail what the heck the scsi code is doing.

changes to scsi LLDDs should always go via linux-scsi.
