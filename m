From: "Smith, Hibbard" <Hibbard.Smith@nasdaq.com>
Subject: RE: 53c8xx_2 driver for SymBios SCSI adapters
Date: Thu, 17 Jun 2004 12:05:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <42DB3021E70A164EB14AAD5181F8280D2B8461@mer-exch2.corp.nasdaq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mer-tsm1.nasdaq.com ([206.200.253.23]:58888 "EHLO
	MER-TSM1.NASDAQ.COM") by vger.kernel.org with ESMTP id S264851AbUFQQGC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 12:06:02 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

Matthew,

I apologize if you feel my message was incorrect or inappropriate.  I posted this problem to this list at the end of May and got no response whatsoever.  I took the liberty of writing directly to you at matthew@wil.cx and that was returned by some server along the way as undeliverable.  My email setup is not broken.  When I searched this list's archive at google with the search term "53c"  the only things I found posted by you were in April and July of 2003.

Obviously, I reached an incorrect conclusion about the state of this driver and it's support.  I am sorry for that.

However, back to the real issue.  Is there anything I can do to increase the verbosity of the driver to get more information about what's happening?  I would be happy to build a kernel in order to obtain more detail.  Since the kernel never really gets up and running, I'll have to transcribe the output and mail it to you.  


Hibbard T. Smith, JR
smitty@essnjay.com

-----Original Message-----
From: willy@www.linux.org.uk [mailto:willy@www.linux.org.uk]On Behalf Of
Matthew Wilcox
Sent: Thursday, June 17, 2004 11:45 AM
To: Smith, Hibbard
Cc: linux-scsi@vger.kernel.org; matthew@wil.cx
Subject: Re: 53c8xx_2 driver for SymBios SCSI adapters


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


