From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Tue, 10 Dec 2002 10:02:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212101602.gBAG2Hi02930@localhost.localdomain>
References: <hch@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA16252
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2002 08:02:27 -0800
In-Reply-To: Message from Christoph Hellwig <hch@infradead.org>
   of "Tue, 10 Dec 2002 13:14:11 GMT." <20021210131411.A30930@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Linus Torvalds <torvalds@transmeta.com>

The tarball contained a lot of extraneous files, but I think I got them all 
weeded out.  I've but the result at:

http://linux-scsi.bkbits.net/scsi-aic7xxx-2.5

it needs to be tested to make sure I captured everything.

Justin, this would be why patches are a lot easier to handle:  we have 
automated scripts to import them rather than having to do error prone manual 
steps.  All I need to know for a patch is where it was based, and I can get 
bitkeeper and the tools to do the rest.

> I'll have a box with three aic7xxx of different types and a hotplug
> pci controller at work and I'd like to help integrating both your
> updates and my hotplug pci changes (which I'll send you and linux-scsi
> for review one done of course) into mainline. 

Hey, I think you just got elected chief tester.  Let me know how the above 
archive fares (and any misc patches that are needed).

Thanks,

James




