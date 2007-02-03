From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [BUG] Unable to handle kernel NULL pointer
 dereference...as_move_to_dispatch+0x11/0x135
Date: Fri, 2 Feb 2007 17:18:10 -0800
Message-ID: <20070202171810.5f089b38.randy.dunlap@oracle.com>
References: <20070122183510.GA19905@andrew-vasquezs-computer.local>
	<20070201232302.905962b6.akpm@linux-foundation.org>
	<20070202205630.GI3737@andrew-vasquezs-computer.local>
	<20070202162541.20e1e930.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933413AbXBCBXn@vger.kernel.org>
In-Reply-To: <20070202162541.20e1e930.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Nigel Kirkland <nigel.kirkland@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2 Feb 2007 16:25:41 -0800 Andrew Morton wrote:

> On Fri, 2 Feb 2007 12:56:30 -0800
> Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> 
> > > >         dt of=/dev/raw/raw1 procs=8 oncerr=abort bs=16k disable=stats limit=2m passes=1000000 pattern=iot dlimit=2048
> 
> What is this mysterious dt command, btw?

I expect that it's the one here:
http://www.scsifaq.org/RMiller_Tools/index.html

---
~Randy
