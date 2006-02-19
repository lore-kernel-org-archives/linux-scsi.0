From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Sun, 19 Feb 2006 21:54:22 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0602191740070.3542@poirot.grange>
References: <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
 <20060213171052.GI18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140000160.18538@poirot.grange>
 <20060214010138.GJ18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140656430.30136@poirot.grange>
 <Pine.LNX.4.60.0602152056530.5682@poirot.grange> <20060215214349.GA7947@igloo.df.lth.se>
 <Pine.LNX.4.60.0602152322190.5682@poirot.grange> <20060216113027.GA3412@igloo.df.lth.se>
 <Pine.LNX.4.60.0602162121020.4944@poirot.grange> <20060218224121.GA21399@igloo.df.lth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:48777 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932243AbWBSUx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 15:53:59 -0500
In-Reply-To: <20060218224121.GA21399@igloo.df.lth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Roubert <roubert@df.lth.se>
Cc: linux-scsi@vger.kernel.org

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
> [262683.504018] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.530334] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.566400] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.569421] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.594330] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262683.620404] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262687.173095] drivers/scsi/dc395x.c[2572]: 2, 0, 0
> [262687.198697] drivers/scsi/dc395x.c[2572]: 4, 0, 0
> [262713.038424] drivers/scsi/dc395x.c[2572]: 2, 0, 0
> [262713.064027] drivers/scsi/dc395x.c[2572]: 4, 0, 0
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

Ok, this tells us, that on your system PIO is triggered only on the 
"write" path and when scattergather are not used. This means that, 1) we 
won't be able to test the most interesting part of the proposed PIO fix - 
scattergather remapping, and 2) your problem might be in hardware rather 
than in software. For the latter I have to ask you if your cables are ok? 
Termination? Maybe replace the cable? Do you have any other SCSI card 
where you also could test your scanner? If you don't think it's a hardware 
problem, we might try to look more exactly how this error (unexpected 
reselect) occurs, how it is related to failing DMA (that's when PIO is 
invoked), and verify if the PIO code is correct / fix it.

After you confirm that your cables and termination are fine, I would ask 
you to do a few more tests to look more exactly at what's happening, and 
to verify at least the non-sg path of my patch. So, would you agree to 
help me further with the tests or would you rather or would you prefer to 
stop now?

Thanks
Guennadi
---
Guennadi Liakhovetski
