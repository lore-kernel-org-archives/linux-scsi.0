From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Write same support
Date: Fri, 3 Feb 2012 14:15:01 -0500
Message-ID: <20120203191501.GB14392@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab2BCTPL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2012 14:15:11 -0500
Content-Disposition: inline
In-Reply-To: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com

Hey Martin,

On Mon, Jan 30 2012 at  7:31pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> 
> Here's my stab at write same support.
> 
> I have mainly tested using blkdev_issue_zeroout which I have modified to
> use write same if available. It will fall back to writing zeroes the
> old-fashioned way if write same fails. I also wired up an ioctl so I
> could trigger zeroout from userland.
> 
> I have gone back and forth over whether blkdev_issue_write_same() should
> take a struct page or a virtual address. It's not such a big deal for
> devices with a 512-byte logical block size. But for devices with 4K it's
> more of an issue. Comments welcome.
> 
> The discovery heuristics is what stopped this patchkit in its tracks
> last year. So I've spent the last few days testing with every exotic
> (i.e. ancient) SCSI device I could find. I'm pretty happy with how it
> works now but it would be great if more people would put it to the test.
> 
> I have a 'writesame' branch available at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git
> 
> for those that want to try it out...

Thanks for getting this together.

Just wanted to let you know I've pulled your branch and will be looking
have dm-thinp make use of write same for the zeroing that it does.

In the process I'll review your code in more detail (so far it looks
good).  So please expect to hear back from me next week.

Mike
