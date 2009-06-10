From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SATA: link online but device misclassified
Date: Wed, 10 Jun 2009 14:34:21 -0600
Message-ID: <20090610203421.GV3274@parisc-linux.org>
References: <cfa4e840906101331q71532d72v5361a72e9b77ce63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38315 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731AbZFJUeT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 16:34:19 -0400
Content-Disposition: inline
In-Reply-To: <cfa4e840906101331q71532d72v5361a72e9b77ce63@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marc Bowes <marcbowes@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Wed, Jun 10, 2009 at 10:31:32PM +0200, Marc Bowes wrote:
> Greetings,
> 
> Firstly, I hope that the SCSI list is the correct place to ask about SATA.

Not really, linux-ide is the preferred place.

> I just got a new chipset (Gigabyte EP45-DQ6) courtesy of a
> competition. This coincided with the death of a hard drive. I had to
> reinstall my Gentoo system on the new hard drive, and hit this issue
> when booting the newly configured Kernel (2.6.29-gentoo-r5):
> 
> ata1: link is slow to respond, please be patient (ready=0)
> ata1: softreset failed (device not ready)
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1: link online but device misclassified, retrying
> ata1: link is slow to respond, please be patient (ready=0)
> ata1: softreset failed (device not ready)
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1: link online but device misclassified, retrying
> ata1: link is slow to respond, please be patient (ready=0)
> ata1: softreset failed (device not ready)
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1: link online but device misclassified, retrying
> ata1: limiting SATA link speed to 1.5 Gbps
> ata1: softreset failed (device not ready)
> ata1: SATA link up to 1.5 Gbps (SStatus 113 SControl 310)
> ata1: link online but device misclassified, device detection might fail
> ata2: link is slow to respond, please be patient (ready=0)
> ata2: softreset failed (device not ready)
> ... (as with ata1)
> 
> This whole process takes a very long time (minutes) to finish. It
> seems to be down-grading two of the four SATA-2 drives to SATA-1
> speeds. The drives are actually SATA-2 drives, and appear to work (at
> full speed) on my Windows 7 install.

What drive model, what ATA controller, and have you checked you're really
getting 250MB/s under Windows?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
