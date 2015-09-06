From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: eata fails to load on post 4.2 kernels
Date: Sun, 06 Sep 2015 21:07:11 +0930
Message-ID: <55EC2567.8000100@internode.on.net>
References: <v03tbc-ufe.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net> <55EC019F.4010209@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:33277 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbbIFLhY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Sep 2015 07:37:24 -0400
In-Reply-To: <55EC019F.4010209@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Arthur Marsh wrote on 06/09/15 18:34:
> Arthur Marsh wrote on 06/09/15 15:58:
>> Hi, I'm seeing the following on post 4.2 kernels, am currently bisecting
>> to find where it started:

First kernel in the bisection that worked without needing irqpoll:

[   73.751482] EATA0: IRQ 10 mapped to IO-APIC IRQ 17.
[   73.776711] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
[   73.802005] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n, 
ip:n, ep:n, pp:y.
[   73.829175] EATA0: 2.0C, PCI 0xd890, IRQ 17, BMST, SG 122, MB 64.
[   73.855552] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
[   73.881125] EATA0: SCSI channel 0 enabled, host target ID 7.
[   73.906599] scsi host3: EATA/DMA 2.0x rev. 8.10.00
[   75.466016] scsi 3:0:6:0: Direct-Access     IBM      DCAS-34330W 
  S65A PQ: 0 ANSI: 2
[   75.491947] scsi 3:0:6:0: cmds/lun 16, sorted, simple tags.
[   77.560139] sd 3:0:6:0: Attached scsi generic sg4 type 0
[   77.586272] sd 3:0:6:0: [sdd] 8466688 512-byte logical blocks: (4.33 
GB/4.03 GiB)
[   77.671836] sd 3:0:6:0: [sdd] Write Protect is off
[   77.700217] sd 3:0:6:0: [sdd] Mode Sense: b3 00 00 08
[   77.725970] sd 3:0:6:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   77.829574]  sdd: sdd1 sdd2 < sdd5 >
[   77.929879] sd 3:0:6:0: [sdd] Attached SCSI disk


