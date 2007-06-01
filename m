From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: megaraid.c, all kernel versions, problem with multi-luns
Date: Fri, 1 Jun 2007 16:42:03 -0700
Message-ID: <20070601164203.f69dee1d.akpm@linux-foundation.org>
References: <ec36785a0705301609t62676c76q3a2b726bf51d50db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756918AbXFAXmJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 19:42:09 -0400
In-Reply-To: <ec36785a0705301609t62676c76q3a2b726bf51d50db@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Reinaldo Carvalho <reinaldow@gmail.com>
Cc: linux-kernel@vger.kernel.org, megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

On Wed, 30 May 2007 20:09:44 -0300
"Reinaldo Carvalho" <reinaldow@gmail.com> wrote:

> Hi,

(cc's added) (CONFIG_SCSI_MULTI_LUN is set)

> I have a Dell PowerEdge Expandable RAID controller, with a hardware
> Raid-5 at Channel 01 running perfectly, and a nCipher Crypter at
> Channel 02.
> 
> This controller doesn't correctly detect devices (e.g. nCipher
> Crypter) with multiples LUNs. Only one LUN is detected.
> 
> At another controller (e.g. Adaptec 79xx) two LUNs were detect. I
> compiled 2.6.8, 2.6.18 and 2.6.21.3 to test megaraid driver and all
> failed detecting two LUNs.
> 
> I think that this is a firmware problem, but i'd like have some opinions.
> 
> I read some docs
> (http://www.suse.de/~garloff/linux/scsi-scan/scsi-scanning.html,
> http://www.ictp.trieste.it/~radionet/nuc1996/ref/howto-html/scsi-howto-2.html)
> and this problem doesn't seem to be simple.
> 
> Best regards,
> 
> More information with Dell PowerEdge Expandable RAID controller (LSI
> Logic MegaRaid):
> 
> Attached devices:
> Host: scsi0 Channel: 00 Id: 06 Lun: 00
>   Vendor: PE/PV    Model: 1x5 SCSI BP      Rev: 1.0
>   Type:   Processor                        ANSI  SCSI revision: 02
> Host: scsi0 Channel: 01 Id: 00 Lun: 00
>   Vendor: nCipher  Model: Fastness Crypto  Rev: 2*00
>   Type:   Processor                        ANSI  SCSI revision: 02
> Host: scsi0 Channel: 02 Id: 00 Lun: 00
>   Vendor: MegaRAID Model: LD 0 RAID5  279G Rev: 522A
>   Type:   Direct-Access                    ANSI  SCSI revision: 02
> 
> 
> 14:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller
> 4 (rev 06)
>         Subsystem: Dell PowerEdge Expandable RAID Controller 4e/Di
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping+ SERR+ FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
> >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64 (32000ns min), Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 22
>         Region 0: Memory at d7ff0000 (32-bit, prefetchable) [size=64K]
>         Region 2: Memory at defc0000 (32-bit, non-prefetchable) [size=256K]
>         Expansion ROM at df000000 [disabled] [size=128K]
>         Capabilities: <access denied>
> 
> 14:0e.0 0104: 1028:0013 (rev 06)
> 
> 
> Information with Adaptec 79xx or others SCSI controllers:
> 
> Host: scsi0 Channel: 01 Id: 00 Lun: 00
>   Vendor: nCipher  Model: Fastness Crypto  Rev: 2*00
>   Type:   Processor                        ANSI  SCSI revision: 02
> Host: scsi0 Channel: 01 Id: 00 Lun: 01
>   Vendor: nCipher  Model: Fastness Crypto  Rev: 2*00
>   Type:   Processor                        ANSI  SCSI revision: 02
> 
> 
