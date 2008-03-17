From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: new kernel oops in recent kernels
Date: Sun, 16 Mar 2008 21:58:11 -0600
Message-ID: <20080317035811.GB26285@parisc-linux.org>
References: <1205680748.3050.29.camel@localhost> <20080316164223.GA26285@parisc-linux.org> <1205692147.5470.3.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44170 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYCQD62 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Mar 2008 23:58:28 -0400
Content-Disposition: inline
In-Reply-To: <1205692147.5470.3.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giuseppe Sacco <giuseppe@eppesuigoccas.homedns.org>
Cc: linux-scsi@vger.kernel.org

On Sun, Mar 16, 2008 at 07:29:07PM +0100, Giuseppe Sacco wrote:
> > It would be interesting to see a disassembly (objdump -dr
> > drivers/scsi/sr_ioctl.o) of sr_drive_status from say 0x40 to 0x60.
> 
> here it is:
> 
> (gdb) disassemble sr_drive_status+0x50
> 0xffffffff802460b0 <sr_drive_status+80>:	bnez	v0,0xffffffff802460fc <sr_drive_status+156>

The thing about objdump -dr is that it gives you the name of the
function that's being called.  gdb apparently doesn't, or would need a
different command from "disassemble".

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
