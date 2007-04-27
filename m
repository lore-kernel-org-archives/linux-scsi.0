From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Fri, 27 Apr 2007 18:53:17 -0500 (CDT)
Message-ID: <20070427235317.71B9DDBA2@gherkin.frus.com>
References: <1177712499.3688.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:50556 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922AbXD0XxS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2007 19:53:18 -0400
In-Reply-To: <1177712499.3688.25.camel@mulgrave.il.steeleye.com>
 "from James Bottomley at Apr 27, 2007 05:21:39 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2007-04-27 at 16:47 -0500, Bob Tracy wrote:
> > I previously reported an ISA DMA issue for the 2.6.12 kernel.  The issue
> > persists through at least 2.6.18.  SCSI controller is an Adaptec
> > AHA-1542B (ISA).
> > 
> > The action "mount -t iso9660 /dev/scd0 /mnt/cdrom -r"
> > 
> > produces
> > 
> > (cdrom detection messages as various modules autoload, then...)
> 
> Knowing what these messages are is would be helpful; it tells me what
> point in the initialisation it got to. 

Sorry about that...  I'm running the DSL-N distribution (based on
Knoppix), and having to transcribe the log messages by hand from the
console, i.e., there's no logfile to cut-and-paste from :-(.  I don't
have access to the machine except on weekdays, but I'll repeat the
crash first thing Monday morning and copy everything that's there...

> I'm interested.
> 
> This is clearly a use_sg==1 path that has failed to bounce the buffer
> for some reason ... and I was contemplating eliminating the GFP_DMA from
> our sr driver because I thought the block bouncing had it covered.
> 
> It might also be helpful to apply this patch.  It should give a stack
> trace of the problem command and not immediately panic the box.

I'll throw together a 2.6.21 kernel with this patch and give it a try.
Again, it will be at least Monday before you hear back from me on this.

Thanks!

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
