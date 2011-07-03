From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PULL] isci: sas controller driver for 3.0
Date: Sat, 02 Jul 2011 19:43:27 -0700
Message-ID: <4E0FD74F.4000701@intel.com>
References: <1309563349.19567.26.camel@dwillia2-linux> <1309646729.2554.17.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32856 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab1GCCn2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Jul 2011 22:43:28 -0400
In-Reply-To: <1309646729.2554.17.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "hare@suse.de" <hare@suse.de>

On 07/02/2011 03:45 PM, James Bottomley wrote:
> Look, this tree is unacceptable because
>
> A. It's not bisectable.  This is what happens when I try a bisection:
[..]
> make[1]: *** [drivers/scsi/isci/init.o] Error 1

This was inadvertent, but breakage is breakage.

> And B. It's got contaminated history like this:

This was on purpose.  We were in the position of stabilizing / 
validating the driver while carrying out the cleanups.  To minimize back 
merges I duplicated upstream fixes/enabling in these instances.  If this 
is de-facto unacceptable I will adjust my tree management going forward. 
  But I don't believe it is given occasions where two maintainers take 
the same patch through their respective trees.

> I need clean history and a bisectable tree ... By Sunday, since this has
> to be in linux-next before the next kernel release, which will likely be
> Monday.

I certainly can rebase this to address the compile breakage.  Although 
this does throw away old commit ids which have seen validation both 
inside and outside of Intel, but that's unavoidable at this point.

The value I see in maintaining the history (even with some re-written 
ids) is:

1/ The history is available in mainline and not a side tree.  Care went 
into the commit changelogs.  They provide driver documentation and 
contain notes about future cleanups and improvements.

2/ Code reviewers are credited with Reported-by tags for the commits 
they generated.

3/ The history is instructive of the dangers of OS abstraction drivers.

> Since the tree is huge, I don't think this is fixable in the timescale,
> so just a single patch will do ... I can construct that, but I need the
> change log from you, please.

I can go either way, but my preference is a rebase to clean up the 
bisection.

--
Dan
