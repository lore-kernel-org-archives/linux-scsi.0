From: Matthew Wilcox <willy@debian.org>
Subject: Re: PATCH: (as141b) Unaligned scatter-gather buffers and usb-storage
Date: Tue, 3 Feb 2004 16:02:35 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040203160235.GN18725@parcelfarce.linux.theplanet.co.uk>
References: <1075737065.1897.7.camel@mulgrave> <Pine.LNX.4.44L0.0402031044390.1161-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:8902 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265954AbUBCQCh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Feb 2004 11:02:37 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0402031044390.1161-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, Feb 03, 2004 at 10:47:38AM -0500, Alan Stern wrote:
> On 2 Feb 2004, James Bottomley wrote:
> > This needs to be unsigned long, otherwise it will print a warning on a
> > 64 bit compile.
> 
> Really?  I'm surprised.  Although I know nothing about the details of 
> using gcc on a 64-bit platform, it seems odd that an explicit cast would 
> generate a warning.  Was that done deliberately, to try and catch 
> inadvertent bugs in address arithmetic?

Yes, it's something like "Cast from pointer to integer of different
size".  If you really want to cast a pointer to an int, you have to do
(int)(long)ptr; or you can use an intermediate variable like "int foo =
(long)ptr;"

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
