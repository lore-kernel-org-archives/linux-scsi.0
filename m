From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4 v2] block: Fixes for bdi handling
Date: Thu,  9 Mar 2017 11:16:20 +0100
Message-ID: <20170309101624.25901-1-jack@suse.cz>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>
List-Id: linux-scsi@vger.kernel.org

Hi!

this is a second revision of the series fixing the most urgent bugs that were
introduced by commit 165a5e22fafb "block: Move bdi_unregister() to
del_gendisk()" and by 0dba1314d4f8 "scsi, block: fix duplicate bdi name
registration crashes".  In fact before these commits we had a different set of
problems in the code but they were less visible :).

Changes since v1:
* Added Acked-by and Tested-by tags
* Changed usage_cnt increment to reinitialize as requested by Tejun and James

								Honza
