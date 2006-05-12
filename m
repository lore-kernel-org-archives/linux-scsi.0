From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 15:22:42 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605121519420.3866@g5.osdl.org>
References: <20060511151456.GD3755@harddisk-recovery.com>
 <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com>
 <20060512171632.GA29077@harddisk-recovery.com> <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
 <20060512203416.GA17120@flint.arm.linux.org.uk> <20060512214354.GP27946@ftp.linux.org.uk>
 <20060512215520.GH17120@flint.arm.linux.org.uk> <20060512220807.GR27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:12243 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932265AbWELWXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 18:23:02 -0400
In-Reply-To: <20060512220807.GR27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Erik Mouw <erik@harddisk-recovery.com>, Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, axboe@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>



On Fri, 12 May 2006, Al Viro wrote:
> 
> Secondary question: who had resurrected that crap?  I distinctly remember
> killing it off...

If you did, I don't think it ever got into the kernel.

It was added by Kay Sievers on Nov 3, 2004, according to the old history 
(back then it was in drivers/block/genhd.c, and the function was called 
"block_hotplug()", but apart from renaming the function and moving the 
file, it's recognizably the same.

Of course, you may have killed off an even earlier incarnation..

			Linus
