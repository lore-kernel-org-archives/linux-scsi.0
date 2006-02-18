From: Fredrik Roubert <roubert@df.lth.se>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Sat, 18 Feb 2006 23:41:21 +0100
Message-ID: <20060218224121.GA21399@igloo.df.lth.se>
References: <Pine.LNX.4.60.0602112153320.3570@poirot.grange> <20060213171052.GI18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140000160.18538@poirot.grange> <20060214010138.GJ18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140656430.30136@poirot.grange> <Pine.LNX.4.60.0602152056530.5682@poirot.grange> <20060215214349.GA7947@igloo.df.lth.se> <Pine.LNX.4.60.0602152322190.5682@poirot.grange> <20060216113027.GA3412@igloo.df.lth.se> <Pine.LNX.4.60.0602162121020.4944@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from igloo.df.lth.se ([194.47.250.47]:25554 "EHLO df.lth.se")
	by vger.kernel.org with ESMTP id S932249AbWBRWl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2006 17:41:29 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0602162121020.4944@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Thu 16 Feb 21:33 CET 2006, Guennadi Liakhovetski wrote:

> I know it's, probably, much easier for you to just through away the d=
amn
> thing (dc315) and get something modern, but - what about the fun?:-)

Oh, just changing hardware to avoid having to solve a software problem
isn't really my style ... ;-)

> Please, try the patch below on the top of your current version - it M=
UST
> trigger.

Here is the dmesg output from that test run:

[262653.162293] dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040=
 v2.05, 2004/03/08
[262653.162314] ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, l=
ow) -> IRQ 19
[262653.404392] dc395x: Used settings: AdapterID=3D07, Speed=3D0(20.0MH=
z), dev_mode=3D0x57
[262653.404398] dc395x:                AdaptMode=3D0x0f, Tags=3D4(16), =
DelayReset=3D1s
[262653.404403] dc395x: Connectors:  Termination: Auto Low High
[262653.404466] dc395x: Performing initial SCSI bus reset
[262653.404985] scsi4 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040=
 v2.05, 2004/03/08
[262655.033158]   Vendor: HP        Model: C2520A            Rev: 3503
[262655.033171]   Type:   Processor                          ANSI SCSI =
revision: 02
[262655.034138]  4:0:2:0: Attached scsi generic sg2 type 3
[262675.061545] drivers/scsi/dc395x.c[2572]: 2, 0, 0
[262676.044080] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.073044] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.102258] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.131515] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.353526] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.402529] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.418709] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.434949] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.451199] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.467416] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.483808] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.500094] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.520097] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.536219] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.599101] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.615137] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.631210] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.647318] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.663580] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.683896] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.747918] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.774339] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.810508] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.813529] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.838307] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.864369] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.936742] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.952765] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.968897] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262676.985074] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262677.001171] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262683.504018] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262683.530334] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262683.566400] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262683.569421] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262683.594330] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262683.620404] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262687.173095] drivers/scsi/dc395x.c[2572]: 2, 0, 0
[262687.198697] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262713.038424] drivers/scsi/dc395x.c[2572]: 2, 0, 0
[262713.064027] drivers/scsi/dc395x.c[2572]: 4, 0, 0
[262725.911499] dc395x: reselect: w/o disconnected cmds <02-0>
[262725.911521] dc395x: disconnect: Unexpected reselection <02-0>
[262845.687267] dc395x: eh_abort: (pid#1007) target=3D<02-0> cmd=3Dffff=
810075fe3dc0
[262845.687274] dc395x: eh_abort: Command in progress<6>dc395x: eh_abor=
t: (pid#1008) target=3D<02-0> cmd=3Dffff810075fe3880
[262845.687280] dc395x: eh_abort: Command was waiting
[262855.668103] dc395x: eh_abort: (pid#1008) target=3D<02-0> cmd=3Dffff=
810075fe3880
[262855.668111] dc395x: eh_abort: Command was waiting
[262855.668119] dc395x: eh_bus_reset: (pid#1007) target=3D<02-0> cmd=3D=
ffff810075fe3dc0
[262855.668640] dc395x: doing_srb_done: pids G:1007(02-0)
[262865.663561] drivers/scsi/dc395x.c[2572]: 2, 0, 0


> With the vanilla 2.6.15 the first "reselect w/o disconnect" message,
> after each boot / insmod dc395x, was _always_ accompanied by requests=
 to
> contact linux-scsi, right?

Yes, it was. (But I didn't do it many times, so it _could_ have been a
coincidence that I got the message each time I tried.)

Cheers // Fredrik Roubert

--=20
S=F6rbyplan 5       |  +46 8 7609169 / +46 708 776974
SE-163 71 Sp=E5nga  |  http://www.df.lth.se/~roubert/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
