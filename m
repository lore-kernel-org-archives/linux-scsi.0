From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] 2.6.2, Partition support for SCSI CDROM...
Date: Thu, 26 Feb 2004 22:22:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403EB806.7090606@tmr.com>
References: <40396134.6030906@realitydiluted.com> <20040222190047.01f6f024.akpm@osdl.org> <40396E8F.4050307@realitydiluted.com> <20040224061130.GC503530@sgi.com> <403B8108.6080606@realitydiluted.com> <20040224170906.GQ25779@parcelfarce.linux.theplanet.co.uk> <20040225101944.GB3832@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tmr.com ([216.238.38.203]:21125 "EHLO gaimboi.tmr.com")
	by vger.kernel.org with ESMTP id S261678AbUB0DXI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 22:23:08 -0500
In-Reply-To: <20040225101944.GB3832@pclin040.win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Matthew Wilcox <willy@debian.org>, "Steven J. Hill" <sjhill@realitydiluted.com>, Jeremy Higdon <jeremy@sgi.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andries Brouwer wrote:
> On Tue, Feb 24, 2004 at 05:09:06PM +0000, Matthew Wilcox wrote:
> 
>>On Tue, Feb 24, 2004 at 11:51:20AM -0500, Steven J. Hill wrote:
> 
> 
>>>+ *    sr0 - first CDROM, whole disk
>>>+ *    sr1 - first CDROM, first partition
>>>+ *
>>>+ *    [...]
>>>+ *
>>>+ *    sr16 - first CDROM, sixteenth partition
>>>+ *    sr17 - second CDROM, whole disk
>>>+ *    sr18 - second CDROM, first partition
>>
>>Umm... no.  I suspect you mean:
>>
>>sr15 - first CDROM, fifteenth partition
>>sr16 - second CDROM, whole disk
>>sr17 - second CDROM, first partition
>>
>>But what a bad idea for device names.  Why not
>>
>>sr0 whole disc
>>sr0a ... sr0o partitions
>>sr1, sr1a ... sr1o
>>
>>It's probably too late to be consistent with discs and call them
>>sra, sra1, ... sra15
>>srb, srb1, ... srb15
> 
> 
> It is standard convention to use numerical suffixes to refer
> to partitions, with a 'p' separator in case the full device
> has a name ending in a digit.
> 
> So: sr0p1, ..., sr0p15, sr1p1, ...

That sounds a LOT better. Of course mknod is your friend, and some of us 
have sr0, sr1 etc, but that's our problem. I think one of the distros 
does it that way, but not one I have here.

-- 
bill davidsen <davidsen@tmr.com>
   CTO TMR Associates, Inc
   Doing interesting things with small computers since 1979
