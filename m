From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Conversion to generic boolean
Date: Tue, 29 Aug 2006 07:58:57 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0608290754550.952@yvahk01.tjqt.qr>
References: <44EFBEFA.2010707@student.ltu.se> <20060828093202.GC8980@infradead.org>
 <20060828171804.09c01846.akpm@osdl.org> <44F3952B.5000500@yahoo.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailer.gwdg.de ([134.76.10.26]:9391 "EHLO mailer.gwdg.de")
	by vger.kernel.org with ESMTP id S1751208AbWH2GEj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 02:04:39 -0400
In-Reply-To: <44F3952B.5000500@yahoo.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>, Richard Knutsson <ricknu-0@student.ltu.se>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


>> I was kinda planning on merging it ;)
>> 
>> I can't say that I'm in love with the patches, but they do improve the
>> situation.
>> 
>> At present we have >50 different definitions of TRUE and gawd knows how
>> many private implementations of various flavours of bool.
>> 
>> In that context, Richard's approach of giving the kernel a single
>> implementation of bool/true/false and then converting things over to use
>> it
>> makes sense.  The other approach would be to go through and nuke the lot,
>> convert them to open-coded 0/1.
>
> Well... we are programming in C here, aren't we ;)

I like it for the annotation we get.

	int fluff;
	if(fluff == 0)

This does not tell if fluff is an integer or a boolean (that is, what the
programmer intended to do -- not the 'int' the compiler sees).
If it had been if(!fluff), it would give a hint, but a lot of places also have
!x where x really is intended to be an integer (and should have been x==0 or
y==NULL resp.)


Jan Engelhardt
-- 
