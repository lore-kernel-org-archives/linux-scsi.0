From: "Qi, Yanling" <Yanling.Qi@lsi.com>
Subject: panic  in sd_rw_initr of SLSE10 PPC
Date: Mon, 5 Feb 2007 19:15:47 -0700
Message-ID: <0F08E10B769EAF4EA2C43A573B8CC87F8BD4FA@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61065 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965458AbXBFCPt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 21:15:49 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id l162EBG0005429
	for <linux-scsi@vger.kernel.org>; Mon, 5 Feb 2007 18:14:11 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id l162FoxR030783
	for <linux-scsi@vger.kernel.org>; Mon, 5 Feb 2007 18:15:51 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

We have a 4GB Emulex HBA with 8.1.6 lpfc driver. The distribution is
SLES10 on PowerPc. When we do a number of target-storage-system reboots,
we see the following panic.
Has any one seen this before?
Thanks,
Yanling

Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA PSERIES LPAR
Modules linked in: ipv6 apparmor aamatch_pcre loop dm_mod ide_cd cdrom
e1000 mppVhba lpfc scsi_transport_fc ipr firmware_class pdc202xx_new
mppUpper sg sd_mod scsi_mod
NIP: C00000000FFEFC40 LR: C00000000FFEFC40 CTR: C000000000250C04
REGS: c00000000ffef910 TRAP: 0400 Tainted: G U (2.6.16.21-0.8-ppc64)
MSR: 8000000010009032 <EE,ME,IR,DR> CR: 22002084 XER: 20000010
TASK = c0000000026531e0[7] 'ksoftirqd/2' THREAD: c000000002658000 CPU: 2
GPR00: C00000000FFEFC40 C00000000FFEFB90 D0000000000B0DE8
0000000000000000
GPR04: C0000000005FF208 0000000000000001 0000000000000000
C0000000006F5078
GPR08: 000000000000F36B C0000000EE8EF000 0000000000000001
C000000000250C04
GPR12: D0000000000819C8 C00000000048B280 0000000000000000
0000000000000000
GPR16: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
GPR20: 0000000000000200 0000000000029000 0000000000029000
0000000000000000
GPR24: 0000000000000000 C00000000F4172F0 0000000000000001
0000000000000000
GPR28: C0000000BA6FD608 D0000000000A8E50 D0000000000AF1D0
C00000000F36B980
NIP [C00000000FFEFC40] 0xc00000000ffefc40
LR [C00000000FFEFC40] 0xc00000000ffefc40
Call Trace:
[C00000000FFEFB90] [C00000000FFEFC40] 0xc00000000ffefc40 (unreliable)
[C00000000FFEFC70] [D000000000036538] .sd_rw_intr+0x2c4/0x310 [sd_mod]
[C00000000FFEFD30] [0000000000014C87] 0x14c87
[C00000000FFEFDC0] [C00000000006B95C] .process_timeout+0x10/0x24
[C00000000FFEFE40] [C00000000006C2B0] .run_timer_softirq+0x1c4/0x240
[C00000000FFEFEF0] [C000000000065B60] .__do_softirq+0x98/0x164
[C00000000FFEFF90] [C000000000024F3C] .call_do_softirq+0x14/0x24
[C00000000FFEF610] [C0000000003AF77F] __func__.21718+0x1294f/0x3f5f0
[C00000000FFEF7C8] [0000000049455320] 0x49455320
Instruction dump:
00000000 45c3a1d9 00000000 000bedff c0000000 0042ce30 00000000 0103ca38
c0000000 004c7c68 00000000 00000000 <c0000000> 0ffefce0 00000000
00000000

Yanling Qi
Engenio Storage Group - LSI Logic
512-794-3713 (Office)
512-794-3702 (Fax)
yanling.qi@lsi.com



Yanling Qi
Engenio Storage Group - LSI Logic
512-794-3713 (Office)
512-794-3702 (Fax)
yanling.qi@lsi.com
 
