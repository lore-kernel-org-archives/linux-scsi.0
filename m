From: "Hommel, Thomas (GE Indust, GE Fanuc)" <Thomas.Hommel@gefanuc.com>
Subject: Mptlinux crashes on kernel 2.6.22.1
Date: Thu, 2 Aug 2007 16:16:49 +0200
Message-ID: <62DDBB9E5E23CC4A929EE46F9427CEAF1F8007@BUDMLVEM04.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ext-nj2ut-10.online-age.net ([64.14.54.240]:1271 "EHLO
	ext-nj2ut-10.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbXHBOmx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Aug 2007 10:42:53 -0400
Received: from int-nj2ut-2.online-age.net (int-nj2ut-2.online-age.net [3.159.237.71])
	by ext-nj2ut-10.online-age.net (8.13.6/8.13.6/20051114-SVVS-TLS-DNSBL) with ESMTP id l72EH2J2028882
	for <linux-scsi@vger.kernel.org>; Thu, 2 Aug 2007 10:17:02 -0400
Received: from cinmlef02.e2k.ad.ge.com (int-nj2ut-2.online-age.net [3.159.237.71])
	by int-nj2ut-2.online-age.net (8.13.6/8.13.6/20050510-SVVS) with ESMTP id l72EH0M7017150
	for <linux-scsi@vger.kernel.org>; Thu, 2 Aug 2007 10:17:00 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mpt_linux_developer@lsi.com

Hello,

I am trying to use a LSI53C1020 based adapter on a PowerPC board with
MPC8641D processor. When initializing, the driver crashes the system
with the error message below. Kernel version is 2.6.22.1, driver
3.04.04. The chip on the adapter is a 53C1020, but the driver detects a
53C1030.
Has anyone experienced similar problems already?

Thanks for your help
Thomas

...
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator,Target}
mptbase: Initiating ioc0 recovery
Unable to handle kernel paging request for data at address 0x00000572
Faulting instruction address: 0xa01f135c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=2 SBS CM6
NIP: a01f135c LR: a01f135c CTR: a000c984
REGS: bffd9e90 TRAP: 0300   Not tainted  (2.6.22.1)
MSR: 00009032 <EE,ME,IR,DR>  CR: 82002048  XER: 00000000
DAR: 00000572, DSISR: 40000000
TASK = bffcc050[9] 'events/0' THREAD: bffd8000 CPU: 0
GPR00: a01f135c bffd9f40 bffcc050 bfffd0c0 bfff4000 00000001 00019400
00000000
GPR08: 0007d710 00000001 a03c2000 bfff4000 22002042 ff9f6b77 0fffbd00
ffffffff
GPR16: 00000001 00000000 007fff00 a0395060 a03730b4 a0370000 a03730b4
a0040000
GPR24: a03730b4 a0370000 00000000 a03a0000 bffd8000 a01f1344 bffef8a4
000002f0
NIP [a01f135c] mptspi_dv_renegotiate_work+0x18/0x120
LR [a01f135c] mptspi_dv_renegotiate_work+0x18/0x120
Call Trace:
[bffd9f40] [a01f135c] mptspi_dv_renegotiate_work+0x18/0x120 (unreliable)
[bffd9f70] [a0034da8] run_workqueue+0xb8/0x170
[bffd9f90] [a00353e0] worker_thread+0x70/0xd4
[bffd9fd0] [a0038e5c] kthread+0x84/0x8c
[bffd9ff0] [a00122f8] kernel_thread+0x44/0x60
Instruction dump:
4bffd8b9 80010024 83e1001c 38210020 7c0803a6 4e800020 7c0802a6 9421ffd0
bf810020 90010034 83e30010 4be7757d <a01f0282> 2f800000 419e009c
813f0000
