From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Oops on scsi_remove_target
Date: Fri, 26 Aug 2005 16:40:08 -0500
Message-ID: <1125092409.5079.107.camel@mulgrave>
References: <430F8637.2060202@xfs.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:12521 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965172AbVHZVkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 17:40:17 -0400
In-Reply-To: <430F8637.2060202@xfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Lord <lord@xfs.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>

On Fri, 2005-08-26 at 16:14 -0500, Stephen Lord wrote:
> Oops: 0000 [#1]
> SMP
> Modules linked in: sg qla2300 qla2xxx scsi_transport_fc aic7xxx 
> scsi_transport_spi sd_mod scsi_mod
> CPU:    2
> EIP:    0060:[<c0191fe3>]    Not tainted VLI
> EFLAGS: 00010282   (2.6.12-kdb)
> EIP is at sysfs_hash_and_remove+0xc/0xfe
> eax: 00000000   ebx: f7e096b0   ecx: 00000000   edx: f885f6b4
> esi: f7e096a8   edi: f885f6ac   ebp: f7feee68   esp: f7feee4c
> ds: 007b   es: 007b   ss: 0068
> Process events/2 (pid: 12, threadinfo=f7fee000 task=f7fef530)
> Stack: 00000002 00000180 f7e09400 00000000 f7e096b0 f7e096a8 f885f6ac 
> f7feee78
>         c0193aaa 00000000 c02f41fe f7feee9c c0227691 f7e096b0 c02f41fe 
> f885f640
>         f885f6b4 f7e096a8 c1a1fff8 c1a20030 f7feeeac c0227702 f7e096a8 
> f7e09400
> Call Trace:
>   [<c0103ec2>] show_stack+0x9a/0xd0
>   [<c010408d>] show_registers+0x175/0x209
>   [<c01042ac>] die+0xfa/0x19c
>   [<c0115200>] do_page_fault+0x239/0x6ee
>   [<c0103ad7>] error_code+0x4f/0x54
>   [<c0193aaa>] sysfs_remove_link+0x1b/0x1d
>   [<c0227691>] class_device_del+0x8e/0xed

This is known and reported and the fix is here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112398346008284

Andrew, Greg, could we do something about getting this fix in.  It's in
sysfs, so I can't really push it.

James


