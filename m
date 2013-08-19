From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: aic94xx and kernel panic
Date: Mon, 19 Aug 2013 10:03:16 +0200
Message-ID: <5211D144.9010703@gmail.com>
References: <520DE220.8040207@inbox.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:53452 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3HSIDI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2013 04:03:08 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so1335586bkb.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2013 01:03:07 -0700 (PDT)
In-Reply-To: <520DE220.8040207@inbox.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Evgeny <sys64@inbox.ru>
Cc: linux-scsi@vger.kernel.org

On 08/16/2013 10:26 AM, Evgeny wrote:
> Hello.
> 
> I've been testing vanilla 3.4.45 (config attached), 3.4.56 kernels on
> centos 5.9 with Adaptec AIC-9410W SAS controller:

There's some fix in libsas about error handle ,  As I remember most of
patch finally merged in 3.7, could you try newer kernel?

KR
Jack
> 
> ------------
> 09:02.0 RAID bus controller: Adaptec AIC-9410W SAS (Razor ASIC RAID)
> (rev 09)
>     Subsystem: Super Micro Computer Inc Device 9280
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
> Stepping- SERR+ FastB2B- DisINTx-
>     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>     Latency: 64 (32000ns min, 26750ns max), Cache Line Size: 32 bytes
>     Interrupt: pin A routed to IRQ 18
>     Region 0: Memory at d8300000 (64-bit, non-prefetchable) [size=256K]
>     Region 2: Memory at d8000000 (64-bit, prefetchable) [size=128K]
>     Region 4: I/O ports at 3000 [size=256]
>     [virtual] Expansion ROM at d8080000 [disabled] [size=512K]
>     Capabilities: [40] PCI-X non-bridge device
>         Command: DPERE- ERO- RBC=4096 OST=8
>         Status: Dev=09:02.0 64bit+ 133MHz+ SCD- USC- DC=simple
> DMMRBC=4096 DMOST=8 DMCRS=128 RSCEM- 266MHz- 533MHz-
>     Capabilities: [58] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>     Capabilities: [e0] MSI: Enable- Count=1/4 Maskable- 64bit+
>         Address: 0000000000000000  Data: 0000
>     Kernel driver in use: aic94xx
>     Kernel modules: aic94xx
> ----------
> 
> Under a heavy load made by bonnie:
> 
> ----------
> bonnie++ -d /tmp/test -x 10000 -s 24g -u root
> ----------
> 
> after 8-14 hours system gets kernel panic (log attached).
> 
> Could anyone help with it?
> 
> 
> Thanks!
> Evgeny

