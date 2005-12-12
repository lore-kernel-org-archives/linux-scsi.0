From: Jens Axboe <axboe@suse.de>
Subject: Re: put_disk in cciss
Date: Mon, 12 Dec 2005 15:04:02 +0100
Message-ID: <20051212140401.GD26185@suse.de>
References: <20051211155753.1d66b65b.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:14951 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751065AbVLLOCj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 09:02:39 -0500
Content-Disposition: inline
In-Reply-To: <20051211155753.1d66b65b.zaitcev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: mikem <mikem@beardog.cca.cpqcorp.net>, coughlan@redhat.com, linux-scsi@vger.kernel.org

On Sun, Dec 11 2005, Pete Zaitcev wrote:
> Hi, Mike:
> 
> Tom pointed me to this:
>  http://marc.theaimsgroup.com/?l=linux-kernel&m=113233643423550&w=2
> 
> Which seems to be in effect, in today's git:
>  http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;h=a9e33db46e68b5432627835ea1945f02d40d861c;hb=e4f5c82a92c2a546a16af1614114eec19120e40a;f=drivers/block/cciss.c
> 
> I suspect that those put_disk calls have to be dropped, because they
> are done in free_hba(). Right?

Yeah it was buggy, a patch has already been submitted on friday to
correct that error.

-- 
Jens Axboe

