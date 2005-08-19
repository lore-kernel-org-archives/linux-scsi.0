From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 16:32:15 -0400
Message-ID: <430641CF.3070709@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>	 <4304DBA1.4050900@pobox.com> <20050819140631.GB12485@lst.de>	 <43061C3C.2020303@adaptec.com> <20050819175459.GA16619@lst.de>	 <43061D57.9060201@adaptec.com> <20050819175929.GA5614@infradead.org>	 <43061FC9.8060301@adaptec.com> <1124481582.5130.88.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:44768 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932219AbVHSUcW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 16:32:22 -0400
In-Reply-To: <1124481582.5130.88.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 08/19/05 15:59, James Bottomley wrote:
> On Fri, 2005-08-19 at 14:07 -0400, Luben Tuikov wrote:
> 
>>So you're doing architectural decisions based on guesses on how
>>Adaptec's (design) driver is?
> 
> 
> You can't have it both ways.  We have to take a fully theoretical

You just made a decision.

> approach (which does involve guesswork) because only the vendors have
> the actual silicon and devices to set up a SAS topology.  However, it

You mean, only the vendor engineers who fall asleep with a bunch of
400 page specs all over their bed.

> has become equally clear that we cannot rely on the vendors to come up
> with a SAS class (and this in not for want of effort on our part).

You just made your position clear.

> The current SAS class will only get validated when it actually meets
> real SAS topologies, which is acceptable in my view just to get this
> project actually moving; code can always be updated later ...

James, the "current SAS class" _will_go_ into the kernel because:
	- It is 3 vendor driven: LSI, Dell, HP.
	- It is being developed by you and Christoph, the people
who decide what goes in or not.

Who cares if it is validated by real SAS topoligies?  You can
_tweak_ it to do so, until you make it unmanageable.
Who cares about the technology and/or if it is anything close
to what the specs say?  Who cares if the LLDD has nothing to
do with the technology or SAS?

I mean after all, the firmware does SAS, not the LLDD,
not a SAS layer, not SCSI Core.

The state of SCSI Core is that it was developed mimicking SPI,
many many years ago, after that there hasn't been any _SCSI_storage_
improvements, other than local inventions.

All the while technologies come (and go): FC, iSCSI, USB Storage,
SATA, SAS and SCSI Core stays pretty much the same.

>>There is a lot more areas where SCSI core needs improvement --
>>*that* would be commendable work.
> 
> Patches are always welcome as long as they solve real problems or make
> real improvements.  Open source is "itch driven" to a large extent (as

Well, as far as I remember it wasn't until Andi Kleen who asked if
anyone has tried scsi command allocation from a slab cache that
I posted my results for a _second_ time.  Then thanks to
Doug L. they went in, along with scsi_done_q.

Everthing is subjective -- your definition of "real problem",
"real improvements" and "solving" would differ from someone else's.
It's all about our point of view.

SCSI Core develops differently from say, the MM subsystem.
The reason, obious to everyone, is that there is so much more
vendor interest in here.

> in if something bites you, you have the impetus to scratch the sore
> place and fix it) ... remember society doesn't encourage the scratching
> of other peoples itches (in public at least) ...

Thank you for letting everyone know your position,
	Luben


> 
> James
> 
> 
> 

