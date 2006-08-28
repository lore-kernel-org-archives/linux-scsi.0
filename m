From: malahal@us.ibm.com
Subject: timeout during sas discovery (aic94xx)
Date: Mon, 28 Aug 2006 16:18:32 -0700
Message-ID: <20060828231832.GA1037@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:18654 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964886AbWH1XSg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 19:18:36 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k7SNIZbc031332
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 19:18:35 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7SNIZCk282402
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 19:18:35 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7SNIY0C027602
	for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2006 19:18:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, alexisb@us.ibm.com

Here are the messages when a task timeout occurs while doing DISCOVERY.
I am running "modprobe aic94xx" and "modprobe -r aic94xx" in a loop on a
maia system with VITESSE expanders. The problems happens after a few
iterations (7-20 iterations). Were were hoping that James phy_reset
patch would fix this but the patch didn't seem to help.

Appreciate any help.

Thanks, Malahal.

--------------------------- (/var/log/)messages -----------------------------
Aug 27 23:31:57 elm3a176 kernel: [  569.913596] sas: DOING DISCOVERY on port 0, pid:6350
Aug 27 23:31:57 elm3a176 kernel: [  569.929862] aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
Aug 27 23:31:57 elm3a176 kernel: [  569.935995] aic94xx: SAS proto IDENTIFY:
Aug 27 23:31:57 elm3a176 kernel: [  569.940295] aic94xx: 00: 20 00 02 02
Aug 27 23:31:57 elm3a176 kernel: [  569.944241] aic94xx: 04: 00 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  569.948189] aic94xx: 08: 00 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  569.952142] aic94xx: 0c: 50 00 1c 17
Aug 27 23:31:57 elm3a176 kernel: [  569.956091] aic94xx: 10: 16 00 40 00
Aug 27 23:31:57 elm3a176 kernel: [  569.960042] aic94xx: 14: 0b 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  569.963991] aic94xx: 18: 00 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  569.967961] aic94xx: control_phy_tasklet_complete: phy4: no device present: oob_status:0x0
Aug 27 23:31:57 elm3a176 kernel: [  569.976934] aic94xx: control_phy_tasklet_complete: phy5: no device present: oob_status:0x0
Aug 27 23:31:57 elm3a176 kernel: [  569.985907] aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
Aug 27 23:31:57 elm3a176 kernel: [  569.994872] aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
Aug 27 23:31:57 elm3a176 kernel: [  570.016464] aic94xx: control_phy_tasklet_complete: phy0, lrate:0x9, proto:0xe
Aug 27 23:31:57 elm3a176 kernel: [  570.023985] aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
Aug 27 23:31:57 elm3a176 kernel: [  570.030119] aic94xx: SAS proto IDENTIFY:
Aug 27 23:31:57 elm3a176 kernel: [  570.034438] aic94xx: 00: 20 00 02 02
Aug 27 23:31:57 elm3a176 kernel: [  570.038385] aic94xx: 04: 00 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  570.042332] aic94xx: 08: 00 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  570.046284] aic94xx: 0c: 50 00 1c 17
Aug 27 23:31:57 elm3a176 kernel: [  570.050235] aic94xx: 10: 16 00 40 00
Aug 27 23:31:57 elm3a176 kernel: [  570.054185] aic94xx: 14: 08 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  570.058134] aic94xx: 18: 00 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  570.062100] aic94xx: control_phy_tasklet_complete: phy1, lrate:0x9, proto:0xe
Aug 27 23:31:57 elm3a176 kernel: [  570.069630] aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
Aug 27 23:31:57 elm3a176 kernel: [  570.075761] aic94xx: SAS proto IDENTIFY:
Aug 27 23:31:57 elm3a176 kernel: [  570.080058] aic94xx: 00: 20 00 02 02
Aug 27 23:31:57 elm3a176 kernel: [  570.084010] aic94xx: 04: 00 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  570.087959] aic94xx: 08: 00 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  570.091910] aic94xx: 0c: 50 00 1c 17
Aug 27 23:31:57 elm3a176 kernel: [  570.095861] aic94xx: 10: 16 00 40 00
Aug 27 23:31:57 elm3a176 kernel: [  570.099811] aic94xx: 14: 09 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  570.103761] aic94xx: 18: 00 00 00 00
Aug 27 23:31:57 elm3a176 kernel: [  570.107978] sas: ex 50001c1716004000 phy00:T attached: 5005076a00000a40
Aug 27 23:31:57 elm3a176 kernel: [  570.115144] sas: ex 50001c1716004000 phy01:T attached: 5005076a00000a40
Aug 27 23:31:57 elm3a176 kernel: [  570.122274] sas: ex 50001c1716004000 phy02:T attached: 5005076a00000a40
Aug 27 23:31:57 elm3a176 kernel: [  570.129425] sas: ex 50001c1716004000 phy03:T attached: 5005076a00000a40
Aug 27 23:31:57 elm3a176 kernel: [  570.136536] sas: ex 50001c1716004000 phy04:T attached: 0000000000000000
Aug 27 23:31:57 elm3a176 kernel: [  570.143674] sas: ex 50001c1716004000 phy05:T attached: 0000000000000000
Aug 27 23:31:57 elm3a176 kernel: [  570.150834] sas: ex 50001c1716004000 phy06:T attached: 0000000000000000
Aug 27 23:31:57 elm3a176 kernel: [  570.158006] sas: ex 50001c1716004000 phy07:T attached: 0000000000000000
Aug 27 23:31:57 elm3a176 kernel: [  570.165129] sas: ex 50001c1716004000 phy08:S attached: 5005076a011061c0
Aug 27 23:31:57 elm3a176 kernel: [  570.172288] sas: ex 50001c1716004000 phy09:S attached: 5005076a011061c0
Aug 27 23:31:57 elm3a176 kernel: [  570.179400] sas: ex 50001c1716004000 phy10:S attached: 5005076a011061c0
Aug 27 23:31:57 elm3a176 kernel: [  570.186541] sas: ex 50001c1716004000 phy11:S attached: 5005076a011061c0
Aug 27 23:31:57 elm3a176 kernel: [  570.193661] sas: ex 50001c1716004000 phy12:D attached: 50001c171600400d
Aug 27 23:31:57 elm3a176 kernel: [  570.201157] sas: ex 5005076a00000a40 phy00:T attached: 50010b9000021585
Aug 27 23:31:57 elm3a176 kernel: [  570.208321] sas: ex 5005076a00000a40 phy01:T attached: 50010b9000021575
Aug 27 23:31:57 elm3a176 kernel: [  570.215599] sas: ex 5005076a00000a40 phy02:T attached: 50010b900004b87e
Aug 27 23:31:57 elm3a176 kernel: [  570.222758] sas: ex 5005076a00000a40 phy03:S attached: 50001c1716004000
Aug 27 23:31:57 elm3a176 kernel: [  570.230071] sas: ex 5005076a00000a40 phy04:S attached: 50001c1716004000
Aug 27 23:31:57 elm3a176 kernel: [  570.237211] sas: ex 5005076a00000a40 phy05:T attached: 0000000000000000
Aug 27 23:31:57 elm3a176 kernel: [  570.244324] sas: ex 5005076a00000a40 phy06:T attached: 0000000000000000
Aug 27 23:31:57 elm3a176 kernel: [  570.251485] sas: ex 5005076a00000a40 phy07:S attached: 50001c1716004000
Aug 27 23:31:57 elm3a176 kernel: [  570.258603] sas: ex 5005076a00000a40 phy08:S attached: 50001c1716004000
Aug 27 23:31:57 elm3a176 kernel: [  570.265924] sas: ex 5005076a00000a40 phy09:T attached: 0000000000000000
Aug 27 23:31:57 elm3a176 kernel: [  570.273161] sas: ex 5005076a00000a40 phy10:T attached: 0000000000000000
Aug 27 23:31:57 elm3a176 kernel: [  570.280649] sas: ex 5005076a00000a40 phy11:T attached: 0000000000000000
Aug 27 23:31:57 elm3a176 kernel: [  570.288143] sas: ex 5005076a00000a40 phy12:D attached: 5005076a00000a4d
Aug 27 23:32:02 elm3a176 kernel: [  575.791927] sas: command 0xffff8100674d9c80, task 0xffff8100727ede00, timed out: EH_NOT_HANDLED
Aug 27 23:32:02 elm3a176 kernel: [  575.801352] sas: Enter sas_scsi_recover_host
Aug 27 23:32:02 elm3a176 kernel: [  575.806022] sas: going over list...
Aug 27 23:32:02 elm3a176 kernel: [  575.809894] sas: trying to find task 0xffff8100727ede00
Aug 27 23:32:02 elm3a176 kernel: [  575.815513] sas: sas_scsi_find_task: aborting task 0xffff8100727ede00
Aug 27 23:32:07 elm3a176 kernel: [  580.818573] aic94xx: tmf timed out
Aug 27 23:32:07 elm3a176 kernel: [  580.822369] aic94xx: tmf came back
Aug 27 23:32:07 elm3a176 kernel: [  580.826164] aic94xx: task not done, clearing nexus
Aug 27 23:32:07 elm3a176 kernel: [  580.831352] aic94xx: asd_clear_nexus_index: PRE
Aug 27 23:32:07 elm3a176 kernel: [  580.836281] aic94xx: asd_clear_nexus_index: POST
Aug 27 23:32:07 elm3a176 kernel: [  580.841280] aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
Aug 27 23:32:07 elm3a176 kernel: [  580.848558] aic94xx: task 0xffff8100727ede00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Aug 27 23:32:07 elm3a176 kernel: [  580.859543] aic94xx: asd_clear_nexus_tasklet_complete: here
Aug 27 23:32:07 elm3a176 kernel: [  580.865505] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Aug 27 23:32:07 elm3a176 kernel: [  580.872077] aic94xx: came back from clear nexus
Aug 27 23:32:07 elm3a176 kernel: [  580.876998] aic94xx: task 0xffff8100727ede00 aborted, res: 0x0
Aug 27 23:32:07 elm3a176 kernel: [  580.883236] sas: sas_scsi_find_task: task 0xffff8100727ede00 is done
Aug 27 23:32:07 elm3a176 kernel: [  580.889980] sas: sas_scsi_recover_host: task 0xffff8100727ede00 is done
Aug 27 23:32:07 elm3a176 kernel: [  580.897004] sas: --- Exit sas_scsi_recover_host
Aug 27 23:32:13 elm3a176 kernel: [  586.401085] sas: command 0xffff8100674d9c80, task 0xffff8100727ed080, timed out: EH_NOT_HANDLED
Aug 27 23:32:13 elm3a176 kernel: [  586.410506] sas: Enter sas_scsi_recover_host
Aug 27 23:32:13 elm3a176 kernel: [  586.415175] sas: going over list...
Aug 27 23:32:13 elm3a176 kernel: [  586.419070] sas: trying to find task 0xffff8100727ed080
Aug 27 23:32:13 elm3a176 kernel: [  586.424711] sas: sas_scsi_find_task: aborting task 0xffff8100727ed080
Aug 27 23:32:18 elm3a176 kernel: [  591.427725] aic94xx: tmf timed out
Aug 27 23:32:18 elm3a176 kernel: [  591.431534] aic94xx: tmf came back
Aug 27 23:32:18 elm3a176 kernel: [  591.435369] aic94xx: task not done, clearing nexus
Aug 27 23:32:18 elm3a176 kernel: [  591.440622] aic94xx: asd_clear_nexus_index: PRE
Aug 27 23:32:18 elm3a176 kernel: [  591.445727] aic94xx: asd_clear_nexus_index: POST
Aug 27 23:32:18 elm3a176 kernel: [  591.450784] aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
Aug 27 23:32:18 elm3a176 kernel: [  591.458063] aic94xx: task 0xffff8100727ed080 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Aug 27 23:32:18 elm3a176 kernel: [  591.469027] aic94xx: asd_clear_nexus_tasklet_complete: here
Aug 27 23:32:18 elm3a176 kernel: [  591.474983] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Aug 27 23:32:18 elm3a176 kernel: [  591.481671] aic94xx: came back from clear nexus
Aug 27 23:32:18 elm3a176 kernel: [  591.486606] aic94xx: task 0xffff8100727ed080 aborted, res: 0x0
Aug 27 23:32:18 elm3a176 kernel: [  591.492843] sas: sas_scsi_find_task: task 0xffff8100727ed080 is done
Aug 27 23:32:18 elm3a176 kernel: [  591.499613] sas: sas_scsi_recover_host: task 0xffff8100727ed080 is done
Aug 27 23:32:18 elm3a176 kernel: [  591.506692] sas: --- Exit sas_scsi_recover_host
Aug 27 23:32:23 elm3a176 kernel: [  597.010245] sas: command 0xffff8100674d9c80, task 0xffff8100727ede00, timed out: EH_NOT_HANDLED
Aug 27 23:32:23 elm3a176 kernel: [  597.019695] sas: Enter sas_scsi_recover_host
Aug 27 23:32:23 elm3a176 kernel: [  597.024380] sas: going over list...
Aug 27 23:32:23 elm3a176 kernel: [  597.028280] sas: trying to find task 0xffff8100727ede00
Aug 27 23:32:23 elm3a176 kernel: [  597.033928] sas: sas_scsi_find_task: aborting task 0xffff8100727ede00
Aug 27 23:32:28 elm3a176 kernel: [  602.036886] aic94xx: tmf timed out
Aug 27 23:32:28 elm3a176 kernel: [  602.040667] aic94xx: tmf came back
Aug 27 23:32:29 elm3a176 kernel: [  602.044441] aic94xx: task not done, clearing nexus
Aug 27 23:32:29 elm3a176 kernel: [  602.049611] aic94xx: asd_clear_nexus_index: PRE
Aug 27 23:32:29 elm3a176 kernel: [  602.054524] aic94xx: asd_clear_nexus_index: POST
Aug 27 23:32:29 elm3a176 kernel: [  602.059520] aic94xx: asd_clear_nexus_index: clear nexus posted, waiting...
Aug 27 23:32:29 elm3a176 kernel: [  602.059570] aic94xx: task 0xffff8100727ede00 done with opcode 0x23 resp 0x0 stat 0x8d but aborted by upper layer!
Aug 27 23:32:29 elm3a176 kernel: [  602.059575] aic94xx: asd_clear_nexus_tasklet_complete: here
Aug 27 23:32:29 elm3a176 kernel: [  602.059578] aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
Aug 27 23:32:29 elm3a176 kernel: [  602.090227] aic94xx: came back from clear nexus
Aug 27 23:32:29 elm3a176 kernel: [  602.095139] aic94xx: task 0xffff8100727ede00 aborted, res: 0x0
Aug 27 23:32:29 elm3a176 kernel: [  602.101355] sas: sas_scsi_find_task: task 0xffff8100727ede00 is done
Aug 27 23:32:29 elm3a176 kernel: [  602.108097] sas: sas_scsi_recover_host: task 0xffff8100727ede00 is done
Aug 27 23:32:29 elm3a176 kernel: [  602.115111] sas: --- Exit sas_scsi_recover_host
Aug 27 23:32:29 elm3a176 kernel: [  602.118260] sas: DONE DISCOVERY on port 0, pid:6350, result:0
Aug 27 23:32:29 elm3a176 kernel: [  602.118272] sas: phy3 matched wide port0
Aug 27 23:32:29 elm3a176 kernel: [  602.118275] sas: phy3 added to port0, phy_mask:0xc
Aug 27 23:32:29 elm3a176 kernel: [  602.118306] sas: phy0 matched wide port0
Aug 27 23:32:29 elm3a176 kernel: [  602.118308] sas: phy0 added to port0, phy_mask:0xd
Aug 27 23:32:29 elm3a176 kernel: [  602.118334] sas: phy1 matched wide port0
Aug 27 23:32:29 elm3a176 kernel: [  602.118336] sas: phy1 added to port0, phy_mask:0xf
Aug 27 23:32:29 elm3a176 kernel: [  602.118965] aic94xx: BUG:sequencer:dl:no ascb?!
Aug 27 23:32:29 elm3a176 kernel: [  602.119422] aic94xx: BUG:sequencer:dl:no ascb?!
