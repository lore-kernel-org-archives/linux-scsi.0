From: Evgeny <sys64@inbox.ru>
Subject: Re: aic94xx and kernel panic
Date: Mon, 19 Aug 2013 15:26:18 +0400
Message-ID: <521200DA.5020601@inbox.ru>
References: <520DE220.8040207@inbox.ru> <5211D144.9010703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.176.42]:50918 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3HSL3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2013 07:29:32 -0400
Received: from smtp14.mail.ru (smtp14.mail.ru [94.100.176.91])
	by fallback4.mail.ru (mPOP.Fallback_MX) with ESMTP id 793C114D9DD
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2013 15:26:44 +0400 (MSK)
In-Reply-To: <5211D144.9010703@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: linux-scsi@vger.kernel.org

I've tried 3.10.2 and it's also affected.

Could you recommend something else?


19.08.2013 12:03, Jack Wang =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 08/16/2013 10:26 AM, Evgeny wrote:
>> Hello.
>>
>> I've been testing vanilla 3.4.45 (config attached), 3.4.56 kernels o=
n
>> centos 5.9 with Adaptec AIC-9410W SAS controller:
> There's some fix in libsas about error handle ,  As I remember most o=
f
> patch finally merged in 3.7, could you try newer kernel?
>
> KR
> Jack
>> ------------
>> 09:02.0 RAID bus controller: Adaptec AIC-9410W SAS (Razor ASIC RAID)
>> (rev 09)
>>      Subsystem: Super Micro Computer Inc Device 9280
>>      Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- Par=
Err+
>> Stepping- SERR+ FastB2B- DisINTx-
>>      Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort=
-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>      Latency: 64 (32000ns min, 26750ns max), Cache Line Size: 32 byt=
es
>>      Interrupt: pin A routed to IRQ 18
>>      Region 0: Memory at d8300000 (64-bit, non-prefetchable) [size=3D=
256K]
>>      Region 2: Memory at d8000000 (64-bit, prefetchable) [size=3D128=
K]
>>      Region 4: I/O ports at 3000 [size=3D256]
>>      [virtual] Expansion ROM at d8080000 [disabled] [size=3D512K]
>>      Capabilities: [40] PCI-X non-bridge device
>>          Command: DPERE- ERO- RBC=3D4096 OST=3D8
>>          Status: Dev=3D09:02.0 64bit+ 133MHz+ SCD- USC- DC=3Dsimple
>> DMMRBC=3D4096 DMOST=3D8 DMCRS=3D128 RSCEM- 266MHz- 533MHz-
>>      Capabilities: [58] Power Management version 2
>>          Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>          Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DScale=3D0 PME-
>>      Capabilities: [e0] MSI: Enable- Count=3D1/4 Maskable- 64bit+
>>          Address: 0000000000000000  Data: 0000
>>      Kernel driver in use: aic94xx
>>      Kernel modules: aic94xx
>> ----------
>>
>> Under a heavy load made by bonnie:
>>
>> ----------
>> bonnie++ -d /tmp/test -x 10000 -s 24g -u root
>> ----------
>>
>> after 8-14 hours system gets kernel panic (log attached).
>>
>> Could anyone help with it?
>>
>>
>> Thanks!
>> Evgeny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
