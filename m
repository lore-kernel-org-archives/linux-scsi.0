From: Andrew Morton <akpm@osdl.org>
Subject: Re: Badness in device_release at drivers/base/core.c:84
Date: Sat, 2 Aug 2003 19:07:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030802190737.3c41d4d8.akpm@osdl.org>
References: <20030801182207.GA3759@blazebox.homeip.net>
	<20030801144455.450d8e52.akpm@osdl.org>
	<20030803015510.GB4696@blazebox.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:20650 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S270980AbTHCCGc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Aug 2003 22:06:32 -0400
In-Reply-To: <20030803015510.GB4696@blazebox.homeip.net>
List-Id: linux-scsi@vger.kernel.org
To: Diffie <diffie@blazebox.homeip.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Diffie <diffie@blazebox.homeip.net> wrote:
>
> After applaying the above patch and testing it still oopses the kernel.
> 
> I noticed same patch in today's mm3 which i compiled and use right now.
> 
> When using cat /proc/scsi/aic7xxx/0 i get segmentation fault and oops
> which i'll attach to this email.
>
> ...
>
>  EIP is at aic7xxx_proc_info+0xc28/0xc80

This is crashing in a different place.  Probably the same bug, showing up
later on.

I don't know if anyone is maintaining aic7xxx_old in 2.7.  It looks like it
was subject to some random untested change a couple of months back.


