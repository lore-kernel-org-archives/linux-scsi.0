From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Tue, 16 Apr 2002 09:56:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204161456.g3GEuo302374@localhost.localdomain>
References: <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Message from "Justin T. Gibbs" <gibbs@scsiguy.com>
   of "Tue, 16 Apr 2002 08:43:43 MDT." <200204161443.g3GEhh990519@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

gibbs@scsiguy.com said:
> In my opinion, the only way to really fix the Linux SCSI layer is to
> rip it out and start over using prior art from systems with functional
> I/O subsystems as a guide to building something enterprise worthy.  As
> soon as the community becomes serious about such an endevor, so will
> I. 8-) 

Not perhaps for ripping it up and starting again.  However, there are more 
ways than one to skin a cat.  If you can outline a set of principles, it may 
be possible to move current development towards them.  How about just the five 
worst things about the current subsystem and how we could address them?

> If you insist on doing this, lets at least preserve the current
> behavior:

> 	/*
> 	 * FIXME: this driver treats deferred errors are fatal for
[...]
> 	if (scsi_sense_valid(SCpnt)
> 	 && scsi_sense_key(SCpnt) == SKEY_CURRENT_ERROR) {

Excellent!  It's a lot more readable for people not versed in sense buffer 
layout, thanks!

James


> I don't believe there are definitions to support the second part of
> the if clause, but there could be. 



