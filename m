From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 10/15] dm linear: support copy
Date: Tue, 15 Jul 2014 15:40:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1407151540340.14632@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Support copy operation in the linear target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-linear.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-3.16-rc4/drivers/md/dm-linear.c
===================================================================
--- linux-3.16-rc4.orig/drivers/md/dm-linear.c	2014-07-11 22:20:27.000000000 +0200
+++ linux-3.16-rc4/drivers/md/dm-linear.c	2014-07-11 22:22:20.000000000 +0200
@@ -56,6 +56,7 @@ static int linear_ctr(struct dm_target *
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
+	ti->copy_supported = 1;
 	ti->private = lc;
 	return 0;
 
