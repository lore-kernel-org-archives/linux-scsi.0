From: Fredrik Roubert <roubert@df.lth.se>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Thu, 16 Feb 2006 12:30:27 +0100
Message-ID: <20060216113027.GA3412@igloo.df.lth.se>
References: <Pine.LNX.4.60.0602130043540.19775@poirot.grange> <20060211011457.GA1839@igloo.df.lth.se> <Pine.LNX.4.60.0602112153320.3570@poirot.grange> <20060213171052.GI18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140000160.18538@poirot.grange> <20060214010138.GJ18853@igloo.df.lth.se> <Pine.LNX.4.60.0602140656430.30136@poirot.grange> <Pine.LNX.4.60.0602152056530.5682@poirot.grange> <20060215214349.GA7947@igloo.df.lth.se> <Pine.LNX.4.60.0602152322190.5682@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from igloo.df.lth.se ([194.47.250.47]:46250 "EHLO df.lth.se")
	by vger.kernel.org with ESMTP id S1751356AbWBPLaf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 06:30:35 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0602152322190.5682@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Wed 15 Feb 23:33 CET 2006, Guennadi Liakhovetski wrote:

> Ok, I will assume that this dump includes the KERN_DEBUG messages too=
 now.

So would I, or else the "reselect: w/o disconnected cmds" wouldn't be
there.

> Still, could you, please, just verify that you don't have anything el=
se
> from dc395x in your /var/log/kern.log (if you have one)?

There is nothing else there, or in /var/log/debug.

> Could you, please, remove / comment out these 2 lines and try again?

OK, this is the log from loading the new module until the second failed
scan:

[49712.862170] dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 =
v2.05, 2004/03/08
[49712.862190] ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, lo=
w) -> IRQ 19
[49713.104766] dc395x: Used settings: AdapterID=3D07, Speed=3D0(20.0MHz=
), dev_mode=3D0x57
[49713.104772] dc395x:                AdaptMode=3D0x0f, Tags=3D4(16), D=
elayReset=3D1s
[49713.104778] dc395x: Connectors:  Termination: Auto Low High
[49713.080481] dc395x: Performing initial SCSI bus reset
[49713.081006] scsi3 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 =
v2.05, 2004/03/08
[49714.608526]   Vendor: HP        Model: C2520A            Rev: 3503
[49714.608566]   Type:   Processor                          ANSI SCSI r=
evision: 02
[49714.608654]  3:0:2:0: Attached scsi generic sg2 type 3
[49787.196864] dc395x: reselect: w/o disconnected cmds <02-0>
[49787.196886] dc395x: disconnect: Unexpected reselection <02-0>
[49906.975135] dc395x: eh_abort: (pid#899) target=3D<02-0> cmd=3Dffff81=
006cbd6d40
[49906.975148] dc395x: eh_abort: Command in progress<6>dc395x: eh_bus_r=
eset: (pid#899) target=3D<02-0> cmd=3Dffff81006cbd6d40
[49906.975675] dc395x: doing_srb_done: pids G:899(02-0)
[50083.137467] dc395x: reselect: w/o disconnected cmds <02-0>
[50083.137487] dc395x: disconnect: Unexpected reselection <02-0>
[50202.914281] dc395x: eh_abort: (pid#3210) target=3D<02-0> cmd=3Dffff8=
1006cbd6640
[50202.914288] dc395x: eh_abort: Command in progress<6>dc395x: eh_bus_r=
eset: (pid#3210) target=3D<02-0> cmd=3Dffff81006cbd6640
[50202.914816] dc395x: doing_srb_done: pids G:3210(02-0)

Cheers // Fredrik Roubert

--=20
S=F6rbyplan 5       |  +46 8 7609169 / +46 708 776974
SE-163 71 Sp=E5nga  |  http://www.df.lth.se/~roubert/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
