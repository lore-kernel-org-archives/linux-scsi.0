From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: please revert [PATCH] s390: zfcp act enhancements
Date: Wed, 17 Nov 2004 16:34:42 +0100
Message-ID: <OF185BBE71.A415A9D9-ONC1256F4F.0053BEA6-C1256F4F.00562DD6@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:22776 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S262348AbUKQPe5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 10:34:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@osdl.org>, BOEBLINGEN LINUX390 <linux390@de.ibm.com>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>





Christoph,

> > I talked with the scsi people about the exports. And yes, the intent
for
> > adding these exports has been to allow the hba abi in its current form
to
> > work with a single add-on module. We know that this is a dead-end path
but
> > they (our scsi folks) want to have a working solution now.
>
> That's not how Linux works.  LLDDs are not supposed to add APIs,

I see your point. Here you say "don't it this way".

> especially not that bad ones.

And here you appear to say "by the way, we'll never do it anyway"
(taking your previous comments on the API into account as well) -
which to some degree contributes to the dilemma faced by lldd writers.

What is your answer to those who wish to manage FC HBAs in a
common way?

Just trying to understand how to proceed from here.
And, yes, neither would I call the HBA API a stroke of genius.

Martin Peschke




                                                                                                                                                 
                      Christoph Hellwig                                                                                                          
                      <hch@lst.de>                 To:       Martin Schwidefsky/Germany/IBM@IBMDE                                                
                      Sent by:                     cc:       Andrew Morton <akpm@osdl.org>, BOEBLINGEN LINUX390/Germany/IBM@IBMDE,               
                      linux-scsi-owner@vger         linux-scsi@vger.kernel.org                                                                   
                      .kernel.org                  Subject:  Re: please revert [PATCH] s390: zfcp act enhancements                               
                                                                                                                                                 
                                                                                                                                                 
                      17/11/2004 15:54                                                                                                           
                                                                                                                                                 
                                                                                                                                                 




> I talked with the scsi people about the exports. And yes, the intent for
> adding these exports has been to allow the hba abi in its current form to
> work with a single add-on module. We know that this is a dead-end path
but
> they (our scsi folks) want to have a working solution now.

That's not how Linux works.  LLDDs are not supposed to add APIs,
especially not that bad ones.

> The standard
> answer to that usually is that the real solution takes as long as it
takes.
> We find ourselves in between these two positions. Not a good place to be.
>
> > > If IBM wants to support a managment API for their FC adapter they
should
> > > participate in the FC transport class development.
> > >
> > > I also want to protest that IBM sends scsi LLDD updates not via
> > > linux-scsi *AGAIN*.
>
> Mea culpa, this has been my fault. This addresses a question that bothers
> me for some time: should zfcp updates go over the arch line to -bk or
would
> it be better to push ALL zfcp updates via linux-scsi and the scsi
maintainers.
> I don't really understand in detail what the heck the scsi code is doing.

changes to scsi LLDDs should always go via linux-scsi.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



