From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.20.4: Software RAID 5: ata13.00: (irq_stat 0x00020002,
 failed to transmit command FIS)
Date: Thu, 5 Apr 2007 13:41:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704051339470.3810@p34.internal.lan>
References: <Pine.LNX.4.64.0704051243080.3810@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704051243080.3810@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Thu, 5 Apr 2007, Justin Piszcz wrote:

> Had a quick question, this is the first time I have seen this happen, and it 
> was not even under during heavy I/O, hardly anything was going on with the 
> box at the time.

.. snip ..

# /usr/bin/time badblocks -b 512 -s -v -w /dev/sdl
Checking for bad blocks in read-write mode
>From block 0 to 293046768
Testing with pattern 0xaa: done
Reading and comparing: done

Not a single bad block on the drive so far.  I have not changed anything
the box physically, with the exception of the BIOS version to V1666 for
an Intel P965 motherboard (DG965WHMKR).  Any idea what or why this
happened?  Is it a kernel or actual HW issue?  What caused this to
occur?  Any thoughts or ideas?

Justin.

