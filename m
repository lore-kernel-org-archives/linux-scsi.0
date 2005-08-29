From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Mon, 29 Aug 2005 13:31:18 -0400
Message-ID: <43134666.1000103@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org> <20050824091230.GB26447@infradead.org> <430F398A.30200@adaptec.com> <20050829171629.GB7875@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:19922 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751153AbVH2RbW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 13:31:22 -0400
In-Reply-To: <20050829171629.GB7875@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 08/29/05 13:16, Christoph Hellwig wrote:
> 
> No need to do silly renaming, but yes, moving creating of scsi_target

I'd do the "silly renaming".  I'd also create "struct scsi_domain_device",
and do "scsi_register_domain_device()".  You know, clean slate...

> structures to the transport does make sense.  It's kinda implicit

There is *nothing* implicit in a Software Project Specification!
Everything must be completely explicit.

> in the todo list I posted.  I also don't really see the point of
> the embedded kobject.

You will, once I post my code.

Think,
	- Hotplugging.
	- More than one "owner" from above.

That is, on a transport you can have a diverse set of
devices.

What if queuecommand() was *not* the only way to send a
task to the device? ;-)

> We actually already have a list in the scsi_target that chains of the
> scsi_device, .devices in scsi_target and .same_target_siblings in scsi_device.
> We just need to use it everywhere.

Yes, I've seen all this.  And I'm sorry to say, but it is *UGLY AS HELL!*

As I said: before implementing an object by a structure in a software
project one has to ask themselves what that object is?  How will it play
with the rest of the objects existsing or to be designed?  What are
the dependencies and what is the dependency graph?  Etc.

First it starts with a white sheet of paper, pencil on one side
and a spec on the other.
 
> Yes. that's what I ment with my item (3) (sorry, I hate all this
> techno-babble, simple language is much easier to understand normally)

Ok, sorry, it's that software specificaion "tehcno-babble" thing talking
through me again.

	Luben

