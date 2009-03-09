From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Getting TRIM working
Date: Mon, 9 Mar 2009 09:17:16 -0600
Message-ID: <20090309151715.GT25995@parisc-linux.org>
References: <20090303190700.GD20511@parisc-linux.org> <49AE47DB.4030200@panasas.com> <20090306191620.GA25995@parisc-linux.org> <49B39DCB.3040203@panasas.com> <1236547480.4861.12.camel@localhost.localdomain> <1236547956.4861.17.camel@localhost.localdomain> <20090309083614.GP25995@parisc-linux.org> <1236607495.3318.5.camel@localhost.localdomain> <20090309141451.GS25995@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51515 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZCIPRS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 11:17:18 -0400
Content-Disposition: inline
In-Reply-To: <20090309141451.GS25995@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>, David Woodhouse <dwmw2@infradead.org>

On Mon, Mar 09, 2009 at 08:14:51AM -0600, Matthew Wilcox wrote:
> I added that in an earlier patch:
> 
> http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=commitdiff;h=f6ebf54cb8045a0cab19d73e26a07945c29d1394;hp=1223b373ae0283221b46e70955eb825679c5a6cb

I've pushed out a new version of the trim patchset:

http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20090309

Now that the ATA bits don't rely on the SCSI bits, I've rearranged the
SCSI bits to be last (since we seem to be closer to having consensus
and shipping devices using TRIM than we do UNMAP).

After I've had a chance to do some testing with these patches, I'd like to
see the first five patches go upstream during the upcoming merge window,
probably through Jeff's IDE tree.

I'd also like the sixth and seventh patches to go upstream during that
merge window, since we also need Read Capacity 16 for 4k sector support,
but that is a different topic for a different thread.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
