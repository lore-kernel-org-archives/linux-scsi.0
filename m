From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Fri, 24 Feb 2006 23:16:21 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0602242310060.5248@poirot.grange>
References: <Pine.LNX.4.60.0602140000160.18538@poirot.grange>
 <20060214010138.GJ18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140656430.30136@poirot.grange>
 <Pine.LNX.4.60.0602152056530.5682@poirot.grange> <20060215214349.GA7947@igloo.df.lth.se>
 <Pine.LNX.4.60.0602152322190.5682@poirot.grange> <20060216113027.GA3412@igloo.df.lth.se>
 <Pine.LNX.4.60.0602162121020.4944@poirot.grange> <20060218224121.GA21399@igloo.df.lth.se>
 <Pine.LNX.4.60.0602191740070.3542@poirot.grange> <20060223153745.GB8644@igloo.df.lth.se>
 <Pine.LNX.4.60.0602232311520.5883@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:9395 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932361AbWBXWQX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Feb 2006 17:16:23 -0500
In-Reply-To: <Pine.LNX.4.60.0602232311520.5883@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Roubert <roubert@df.lth.se>
Cc: linux-scsi@vger.kernel.org

On Thu, 23 Feb 2006, Guennadi Liakhovetski wrote:

> Great! While I am preparing a new debugging patch, could you, perhaps, 
> test your scanner + dc315u + pc with some live Linux CDs? Some 32-bit i386 
> like Knoppix, also interesting with 2.6 and 2.4 kernel?

While at it, at the bottom of this email there's a new debugging patch. 
Please, try and send the output back as usual.

One more question to your previous report:


On Sat, 18 Feb 2006, Fredrik Roubert wrote:

> Here is the dmesg output from that test run:
> 
> [262653.162293] dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
> [262653.162314] ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, low) -> IRQ 19
> [262653.404392] dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), dev_mode=0x57
> [262653.404398] dc395x:                AdaptMode=0x0f, Tags=4(16), DelayReset=1s
> [262653.404403] dc395x: Connectors:  Termination: Auto Low High
> [262653.404466] dc395x: Performing initial SCSI bus reset
> [262653.404985] scsi4 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
> [262655.033158]   Vendor: HP        Model: C2520A            Rev: 3503
> [262655.033171]   Type:   Processor                          ANSI SCSI revision: 02
> [262655.034138]  4:0:2:0: Attached scsi generic sg2 type 3

In this 20 seconds, I presume, you started the scan, right?

> [262675.061545] drivers/scsi/dc395x.c[2572]: 2, 0, 0
> [262676.044080] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.073044] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.102258] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.131515] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.353526] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.402529] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.418709] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.434949] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.451199] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.467416] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.483808] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.500094] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.520097] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.536219] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.599101] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.615137] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.631210] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.647318] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.663580] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.683896] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.747918] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.774339] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.810508] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.813529] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.838307] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.864369] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.936742] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.952765] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.968897] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262676.985074] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262677.001171] drivers/scsi/dc395x.c[2572]: 4, 0, 0

Do you have an idea what happened during these 7 seconds?

> [262683.504018] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.530334] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.566400] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.569421] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.594330] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.620404] drivers/scsi/dc395x.c[2572]: 4, 0, 0

4 more seconds...

> [262687.173095] drivers/scsi/dc395x.c[2572]: 2, 0, 0
> [262687.198697] drivers/scsi/dc395x.c[2572]: 4, 0, 0

6 more...

> [262713.038424] drivers/scsi/dc395x.c[2572]: 2, 0, 0
> [262713.064027] drivers/scsi/dc395x.c[2572]: 4, 0, 0

Now, 12 seconds later - "unexpected reselect".

> [262725.911499] dc395x: reselect: w/o disconnected cmds <02-0>
> [262725.911521] dc395x: disconnect: Unexpected reselection <02-0>
> [262845.687267] dc395x: eh_abort: (pid#1007) target=<02-0> cmd=ffff810075fe3dc0
> [262845.687274] dc395x: eh_abort: Command in progress<6>dc395x: eh_abort: (pid#1008) target=<02-0> cmd=ffff810075fe3880
> [262845.687280] dc395x: eh_abort: Command was waiting
> [262855.668103] dc395x: eh_abort: (pid#1008) target=<02-0> cmd=ffff810075fe3880
> [262855.668111] dc395x: eh_abort: Command was waiting
> [262855.668119] dc395x: eh_bus_reset: (pid#1007) target=<02-0> cmd=ffff810075fe3dc0
> [262855.668640] dc395x: doing_srb_done: pids G:1007(02-0)
> [262865.663561] drivers/scsi/dc395x.c[2572]: 2, 0, 0

So, do you have an idea - is it really so that you start the scanning 
in the first 20-second long interval, and then it just lasts all the time 
after that, or was there a preview, or something else?

Thanks
Guennadi
---
Guennadi Liakhovetski

diff -u a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2006-02-24 22:43:53.000000000 +0100
+++ b/drivers/scsi/dc395x.c	2006-02-24 22:44:41.000000000 +0100
@@ -64,6 +64,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_dbg.h>
 
 #include "dc395x.h"
 
@@ -1403,10 +1404,10 @@
 	}
 	srb = find_cmd(cmd, &dcb->srb_going_list);
 	if (srb) {
-		dprintkl(KERN_DEBUG, "eh_abort: Command in progress");
+		dprintkl(KERN_DEBUG, "eh_abort: Command in progress\n");
 		/* XXX: Should abort the command here */
 	} else {
-		dprintkl(KERN_DEBUG, "eh_abort: Command not found");
+		dprintkl(KERN_DEBUG, "eh_abort: Command not found\n");
 	}
 	return FAILED;
 }
@@ -2569,8 +2570,10 @@
 				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
 				     CFG2_WIDEFIFO);
 
-			printk(KERN_INFO "%s[%d]: %u, %x, %d\n", __FILE__, __LINE__,
-			       left_io, srb->dcb->sync_period & WIDE_SYNC, srb->cmd->use_sg);
+			printk(KERN_INFO "%s[%d]: %u/%u, %p, %d\n", __FILE__, __LINE__,
+			       left_io, srb->request_length,
+			       srb->cmd, srb->cmd->use_sg);
+			__scsi_print_command(srb->cmd->data_cmnd);
 
 			while (left_io) {
 				unsigned char *virt, *base = NULL;
