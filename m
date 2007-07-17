From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: advansys cleanup
Date: Tue, 17 Jul 2007 08:24:55 -0600
Message-ID: <20070717142455.GB14791@parisc-linux.org>
References: <20070716202815.GQ13826@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42959 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbXGQOY5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 10:24:57 -0400
Content-Disposition: inline
In-Reply-To: <20070716202815.GQ13826@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeffreyfreeman@syncleus.com, ken@krwtech.com, Christoph Hellwig <hch@infradead.org>

On Mon, Jul 16, 2007 at 02:28:15PM -0600, Matthew Wilcox wrote:
> I have to run, but here's what I've benn working on today if anyone
> wants to test:
> 
> http://git.kernel.org/pub/scm/linux/kernel/git/willy/advansys-2.6.git

I was in so much of a hurry that I got the URL wrong.  It is:

http://git.kernel.org/?p=linux/kernel/git/willy/advansys.git;a=summary

I've posted the four patches that this git contains.

I don't have an advansys card of my own, so I'm looking for testers.
It compiles cleanly, but that's about the best I can say about it.
I'm looking to do some more work on it today, including fixing the
dreadful job somebody did of removing the check_region calls.  It'd be
helpful to know that this much works (and if it doesn't, at which point
in the patch series it stops working).

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
