From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.21 broke arm scsi on qemu -M volatilepb
Date: Thu, 10 May 2007 21:20:46 -0700
Message-ID: <20070510212046.477dfed1.randy.dunlap@oracle.com>
References: <200705102359.11315.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:58246 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbXEKERb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 00:17:31 -0400
In-Reply-To: <200705102359.11315.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>

[adding linux-scsi]

On Thu, 10 May 2007 23:59:10 -0400 Rob Landley wrote:

> Booting a 2.6.20 kernel under qemu works fine and gets me to a shell prompt, 
> but booting a 2.6.21.1 kernel cycles endlessly on scsi, going:
> 
> Loading iSCSI transport class v2.0-724.
> PCI: enabling device 0000:00:0c.0 (0140 -> 0143)
> sym0: <895a> rev 0x0 at pci 0000:00:0c.0 irq 0
> sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
> sym0: SCSI BUS has been reset.
> scsi0 : sym-2.2.3
> scsi 0:0:0:0: ABORT operation started.
> scsi 0:0:0:0: ABORT operation timed-out.
> scsi 0:0:0:0: DEVICE RESET operation started.
> scsi 0:0:0:0: DEVICE RESET operation timed-out.
> scsi 0:0:0:0: BUS RESET operation started.
> scsi 0:0:0:0: BUS RESET operation timed-out.
> scsi 0:0:0:0: HOST RESET operation started.
> sym0: SCSI BUS has been reset.
> ...
> And so on.
> 
> If you're interested in reproducing this, download the most recent 
> http://landley.net/hg/firmware snapshot (links up top), run "./build.sh 
> armv4l", and when that's done "cd build" and "./run-armv4l.sh".
> 
> Is this a known issue?  A quick google for "arm scsi 2.6.21" didn't turn up 
> anything relevant...
> 
> Rob


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
