From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Fri, 19 Aug 2005 15:59:41 -0400
Message-ID: <1124481582.5130.88.camel@mulgrave>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com>
	 <4304DBA1.4050900@pobox.com> <20050819140631.GB12485@lst.de>
	 <43061C3C.2020303@adaptec.com> <20050819175459.GA16619@lst.de>
	 <43061D57.9060201@adaptec.com> <20050819175929.GA5614@infradead.org>
	 <43061FC9.8060301@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:22933 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932687AbVHSUAR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2005 16:00:17 -0400
In-Reply-To: <43061FC9.8060301@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-08-19 at 14:07 -0400, Luben Tuikov wrote:
> So you're doing architectural decisions based on guesses on how
> Adaptec's (design) driver is?

You can't have it both ways.  We have to take a fully theoretical
approach (which does involve guesswork) because only the vendors have
the actual silicon and devices to set up a SAS topology.  However, it
has become equally clear that we cannot rely on the vendors to come up
with a SAS class (and this in not for want of effort on our part).

The current SAS class will only get validated when it actually meets
real SAS topologies, which is acceptable in my view just to get this
project actually moving; code can always be updated later ...

> There is a lot more areas where SCSI core needs improvement --
> *that* would be commendable work.

Patches are always welcome as long as they solve real problems or make
real improvements.  Open source is "itch driven" to a large extent (as
in if something bites you, you have the impetus to scratch the sore
place and fix it) ... remember society doesn't encourage the scratching
of other peoples itches (in public at least) ...

James


