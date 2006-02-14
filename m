From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Tue, 14 Feb 2006 06:59:45 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0602140656430.30136@poirot.grange>
References: <20060211011457.GA1839@igloo.df.lth.se>
 <Pine.LNX.4.60.0602112153320.3570@poirot.grange> <Pine.LNX.4.60.0602130043540.19775@poirot.grange>
 <20060211011457.GA1839@igloo.df.lth.se> <Pine.LNX.4.60.0602112153320.3570@poirot.grange>
 <20060213171052.GI18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140000160.18538@poirot.grange>
 <20060214010138.GJ18853@igloo.df.lth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:60550 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1030428AbWBNF7h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Feb 2006 00:59:37 -0500
In-Reply-To: <20060214010138.GJ18853@igloo.df.lth.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Roubert <roubert@df.lth.se>
Cc: linux-scsi@vger.kernel.org

I think, it is better to keep linux-scsi in CC, if you don't mind.

On Tue, 14 Feb 2006, Fredrik Roubert wrote:

> Feb 14 01:55:12 skalman kernel: dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
> Feb 14 01:55:12 skalman kernel: ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, low) -> IRQ 19
> Feb 14 01:55:12 skalman kernel: dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), dev_mode=0x57
> Feb 14 01:55:12 skalman kernel: dc395x:                AdaptMode=0x0f, Tags=4(16), DelayReset=1s
> Feb 14 01:55:12 skalman kernel: dc395x: Connectors:  Termination: Auto Low High
> Feb 14 01:55:12 skalman kernel: dc395x: Performing initial SCSI bus reset
> Feb 14 01:55:12 skalman kernel: scsi4 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
> Feb 14 01:55:13 skalman kernel:   Vendor: HP        Model: C2520A            Rev: 3503
> Feb 14 01:55:13 skalman kernel:   Type:   Processor                          ANSI SCSI revision: 02
> Feb 14 01:55:13 skalman kernel:  4:0:2:0: Attached scsi generic sg2 type 3
> Feb 14 01:56:11 skalman kernel: dc395x: reselect: w/o disconnected cmds <02-0>
> Feb 14 01:56:11 skalman kernel: dc395x: disconnect: Unexpected reselection <02-0>
> Feb 14 01:58:11 skalman kernel: dc395x: eh_abort: (pid#669) target=<02-0> cmd=ffff810009067cc0
> Feb 14 01:58:11 skalman kernel: dc395x: eh_abort: Command in progress<6>dc395x: eh_bus_reset: (pid#669) target=<02-0> cmd=ffff810009067cc0
> Feb 14 01:58:11 skalman kernel: dc395x: doing_srb_done: pids G:669(02-0)

Hm, is it from /var/log/messages? Looks like your KERN_DEBUG messages do 
not come there. Perhaps in /var/log/kern.log or similar? Please have a 
look if you find them. Alternatively, I think, dmesg should also output 
them.

Thanks
Guennadi
---
Guennadi Liakhovetski
