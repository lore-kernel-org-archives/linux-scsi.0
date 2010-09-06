From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: [PATCH 07/14] drivers/scsi: Removing undead ifdef __ISAPNP__
Date: Mon, 6 Sep 2010 16:36:30 +0200
Message-ID: <1dc9bb1263c30b452523faea097f016c9706d3ab.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Juergen E. Fischer" <fischer@norbit.de>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
List-Id: linux-scsi@vger.kernel.org

The __ISAPNP__ ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/scsi/aha152x.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 8eab858..08f59da 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3806,9 +3806,7 @@ static int __init aha152x_init(void)
 #if defined(AHA152X_DEBUG)
 			setup[setup_count].debug       = DEBUG_DEFAULT;
 #endif
-#if defined(__ISAPNP__)
 			pnpdev[setup_count]            = dev;
-#endif
 			printk (KERN_INFO
 				"aha152x: found ISAPnP adapter at io=0x%03x, irq=%d\n",
 				setup[setup_count].io_port, setup[setup_count].irq);
-- 
1.7.0.4
