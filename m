From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: [PATCH 0/4] block: Fixes for bdi handling
Date: Thu, 9 Mar 2017 19:35:12 +1030
Message-ID: <c29abefb-d016-c00c-e4d2-3dfd8ec94f89@internode.on.net>
References: <20170308164834.14302-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:13632 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753874AbdCIJZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2017 04:25:45 -0500
In-Reply-To: <20170308164834.14302-1-jack@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, linux-scsi@vger.kernel.org



Jan Kara wrote on 09/03/17 03:18:
> Hi!
>
> patches in this series fix the most urgent bugs that were introduced by commit
> 165a5e22fafb "block: Move bdi_unregister() to del_gendisk()" and by
> 0dba1314d4f8 "scsi, block: fix duplicate bdi name registration crashes".
> In fact before these commits we had a different set of problems in the
> code but they were less visible :).
>
> I'm still waiting for test confirmation from Omar and Arthur Marsh who reported
> issues but I'm not able to hit any problem anymore in my testing.  I think it
> would be nice to get the patches to rc2 so to speed up things I'm posting the
> patches now so that review can happen in parallel with the testing.
>
> Other BDI handling fixes I have in my queue can wait a bit more since they are
> either theoretical or long-standing issues. So I'll repost them once these four
> are sorted out.
>
> 								Honza
>

Sorry for the delay in replying, I had to leave the kernel with all 4 
patches applied rebuilding while I was at work and just booted it.

I've only done a kexec reboot so far but there were no problems - no 
errors in dmesg, all disks were recognised and all attempted mounts worked.

Thanks very much for the quick fix!

Arthur.
