From: Matthew Wilcox <willy@debian.org>
Subject: Re: 53c8xx_2 driver for SymBios SCSI adapters
Date: Thu, 17 Jun 2004 16:44:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617154459.GB20511@parcelfarce.linux.theplanet.co.uk>
References: <42DB3021E70A164EB14AAD5181F8280D2B8460@mer-exch2.corp.nasdaq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16814 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266546AbUFQPo7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 11:44:59 -0400
Content-Disposition: inline
In-Reply-To: <42DB3021E70A164EB14AAD5181F8280D2B8460@mer-exch2.corp.nasdaq.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smith, Hibbard" <Hibbard.Smith@nasdaq.com>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

On Thu, Jun 17, 2004 at 11:31:42AM -0400, Smith, Hibbard wrote:
> Is anyone actually maintaining or working on this driver??

Er, yes.

> Somewhere between 2.4.26 and 2.6.5 it got broken.  It's still broken
> in 2.6.6 and 2.6.7 rc2.  The MAINTAINERs file lists the maintainer as
> Matthew Wilcox (email matthew@wil.cx).  Emails to that address bounce.

Why do they bounce?  I suspect you have a broken mail setup.

> Articles to this list get no response from anyone.  The last posting
> in this list from Matthew (that I can find) is back in 2003.  I have
> previously posted to this list about this problem.

I suggest you try harder then.  I've posted several times in the last week.

> The bug has been reported in this mailing list which, apparently, is the
> only way to communicate with the developer listed in the MAINTAINERS file.
> The bug has also been reported a couple of times in the Fedora Bugzilla
> for core 2.

I don't go round reading random distro bugzillas.

> When the kernel is initializing, the driver recognizes the SymBios
> 53c1010-33 chips on the motherboard, goes through several initialization
> messages and then begins domain validation.  At this point, everything
> hangs for awhile, then aborts and starts a cycle of SCSI bus resets from
> which it never recovers.  The system then hangs for up to a half hour.
> That's the longest I've let it sit.  I'm sure it's gone for good.

I had a report of this last week.  I was travelling so didn't have time
to deal with it yet.

> I would be happy to attempt to get more information, if someone could
> tell me how to get more verbosity from the driver.  The 53c8xx_2.txt
> file in the Documentation/scsi directory is very old and out of date,
> and the driver options it talks about appear to no longer work.

I have been updating it.  Send a patch.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
