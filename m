From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: READ CAPACITY failed on ia64
Date: Tue, 14 Aug 2007 06:08:08 -0600
Message-ID: <20070814120808.GM16277@parisc-linux.org>
References: <20070814115005.GA31094@bsd.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40623 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760826AbXHNMIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 08:08:09 -0400
Content-Disposition: inline
In-Reply-To: <20070814115005.GA31094@bsd.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Nagy <robert.nagy@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 14, 2007 at 01:50:05PM +0200, Robert Nagy wrote:
> In this box I get the following error message:

If you turn on CONFIG_SCSI_CONSTANTS, you'll get the error message
decoded for you, but ...

> sd 0:0:2:0: [sdb] READ CAPACITY failed
> sd 0:0:2:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
> sd 0:0:2:0: [sdb] Sense Key : 0x3 [current]

        "Medium Error",     /* 3: Data error detected on the medium */

> sd 0:0:2:0: [sdb] ASC=0x31 ASCQ=0x0

        {0x3100, "Medium format corrupted"},

> I am currently running 2.6.22 but I've also tried with serveral other
> (and older) kernels and it still can't get the capacity of the disk.

Looks like the disc is broken.  Given that a scsiformat doesn't fix it,
it's probably irretrievable.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
