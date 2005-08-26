From: Andrew Morton <akpm@osdl.org>
Subject: Re: Oops on scsi_remove_target
Date: Fri, 26 Aug 2005 14:47:07 -0700
Message-ID: <20050826144707.2915909e.akpm@osdl.org>
References: <430F8637.2060202@xfs.org>
	<1125092409.5079.107.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:24205 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030263AbVHZVsk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 17:48:40 -0400
In-Reply-To: <1125092409.5079.107.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: lord@xfs.org, linux-scsi@vger.kernel.org, greg@kroah.com

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> >   [<c01042ac>] die+0xfa/0x19c
> >   [<c0115200>] do_page_fault+0x239/0x6ee
> >   [<c0103ad7>] error_code+0x4f/0x54
> >   [<c0193aaa>] sysfs_remove_link+0x1b/0x1d
> >   [<c0227691>] class_device_del+0x8e/0xed
> 
> This is known and reported and the fix is here:
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112398346008284
> 
> Andrew, Greg, could we do something about getting this fix in.  It's in
> sysfs, so I can't really push it.
> 

Well it may not be right, but it looks fine as a
fix-for-2.6.13-coz-gregs-on-vacation.

Could you send me the diff?  I'll add it to today's
batch-of-patches-to-send-to-linus-after-having-worked-out-wtf-git-has-done-this-time.

