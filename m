From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] block: Fixes for bdi handling
Date: Wed,  8 Mar 2017 17:48:30 +0100
Message-ID: <20170308164834.14302-1-jack@suse.cz>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34820 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752720AbdCHQtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Mar 2017 11:49:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>

Hi!

patches in this series fix the most urgent bugs that were introduced by commit
165a5e22fafb "block: Move bdi_unregister() to del_gendisk()" and by
0dba1314d4f8 "scsi, block: fix duplicate bdi name registration crashes".
In fact before these commits we had a different set of problems in the
code but they were less visible :).

I'm still waiting for test confirmation from Omar and Arthur Marsh who reported
issues but I'm not able to hit any problem anymore in my testing.  I think it
would be nice to get the patches to rc2 so to speed up things I'm posting the
patches now so that review can happen in parallel with the testing.

Other BDI handling fixes I have in my queue can wait a bit more since they are
either theoretical or long-standing issues. So I'll repost them once these four
are sorted out.

								Honza
