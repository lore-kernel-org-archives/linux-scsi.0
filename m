From: Karen Shaeffer <shaeffer@neuralscape.com>
Subject: Re: MPT Fusion initialization in 2.6.23.12
Date: Wed, 16 Jan 2008 00:50:11 -0800
Message-ID: <20080116085011.GA5392@synapse.neuralscape.com>
References: <da824cf30801141641u7baac682haa1ff06dddc5da99@mail.gmail.com> <664A4EBB07F29743873A87CF62C26D70C5D129@NAMAIL4.ad.lsil.com> <20080115163749.GB12884@synapse.neuralscape.com> <da824cf30801150853wbf64e5aj802ae12c96145247@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from synapse.neuralscape.com ([198.144.200.82]:43879 "EHLO
	neuralscape.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYAPIuO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jan 2008 03:50:14 -0500
Content-Disposition: inline
In-Reply-To: <da824cf30801150853wbf64e5aj802ae12c96145247@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org

On Tue, Jan 15, 2008 at 08:53:05AM -0800, Grant Grundler wrote:
> On Jan 15, 2008 8:37 AM, Karen Shaeffer <shaeffer@neuralscape.com> wrote:
> > This is a Sun X4200 M2 Netra server. The LSI SAS1064 "RAID enabled"
> > Ultra320 SCSI controller supports RAID0, RAID1, and RAID1E modes. The
> > implementation uses RAID1, so this chip is RAID-enabled.
> 
> http://www.sun.com/servers/netra/x4200/specs.xml says you only have SAS
> and NOT u320 SCSI (unless an add-on u320 SCSI card is installed).
> LSI u320 SCSI cards can  support RAID0/1 but HP-UX didn't ship with RAID
> enabled because of Firmware bugs (which may have been fixed in the mean time).
> 
> If you post "lspci -vt" and/or "lspci" output, it would be clear
> what's in the box.

Hi,

~$ lspci -vt
-+-[80]-+-00.0  nVidia Corporation: Unknown device 005e
 |      +-01.0  nVidia Corporation: Unknown device 00d3
 |      +-0a.0  nVidia Corporation: Unknown device 0057
 |      +-0b.0-[81]--
 |      +-0c.0-[82]--
 |      +-0d.0-[83-85]--+-00.0-[85]--
 |      |               \-00.2-[84]--
 |      +-0e.0-[86]--
 |      +-10.0-[87]--
 |      +-10.1  Advanced Micro Devices [AMD]: Unknown device 7459
 |      +-11.0-[8e]--+-01.0  Intel Corp. 82546EB Gigabit Ethernet Controller (Copper)
 |      |            +-01.1  Intel Corp. 82546EB Gigabit Ethernet Controller (Copper)
 |      |            \-02.0  LSI Logic / Symbios Logic: Unknown device 0050
 |      \-11.1  Advanced Micro Devices [AMD]: Unknown device 7459
 \-[00]-+-00.0  nVidia Corporation: Unknown device 005e
        +-01.0  nVidia Corporation: Unknown device 0051
        +-01.1  nVidia Corporation: Unknown device 0052
        +-02.0  nVidia Corporation: Unknown device 005a
        +-02.1  nVidia Corporation: Unknown device 005b
        +-06.0  nVidia Corporation: Unknown device 0053
        +-09.0-[01]----03.0  ATI Technologies Inc Rage XL
        +-0a.0  nVidia Corporation: Unknown device 0057
        +-0b.0-[02]--
        +-0c.0-[03]--
        +-0d.0-[04-06]--+-00.0-[06]--
        |               \-00.2-[05]--
        +-0e.0-[07]--
        +-18.0  Advanced Micro Devices [AMD] K8 NorthBridge
        +-18.1  Advanced Micro Devices [AMD] K8 NorthBridge
        +-18.2  Advanced Micro Devices [AMD] K8 NorthBridge
        +-18.3  Advanced Micro Devices [AMD] K8 NorthBridge
        +-19.0  Advanced Micro Devices [AMD] K8 NorthBridge
        +-19.1  Advanced Micro Devices [AMD] K8 NorthBridge
        +-19.2  Advanced Micro Devices [AMD] K8 NorthBridge
        \-19.3  Advanced Micro Devices [AMD] K8 NorthBridge

8e:02.0 SCSI storage controller: LSI Logic / Symbios Logic: Unknown device 0050 (rev 02)
        Subsystem: LSI Logic / Symbios Logic: Unknown device 3060
        Flags: bus master, 66Mhz, medium devsel, latency 72, IRQ 18
        I/O ports at e400 [disabled] [size=256]
        Memory at fe9bc000 (64-bit, non-prefetchable) [size=16K]
        Memory at fe9a0000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at fe600000 [disabled] [size=2M]
        Capabilities: [50] Power Management version 2
        Capabilities: [98] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
        Capabilities: [68] PCI-X non-bridge device.
        Capabilities: [b0] #11 [0000]

This is, of course, on the system board. I will be following up
on this issue soon. I was swamped with other issues today.

Thanks,
Karen
-- 
 Karen Shaeffer
 Neuralscape, Palo Alto, Ca. 94306
 shaeffer@neuralscape.com  http://www.neuralscape.com
