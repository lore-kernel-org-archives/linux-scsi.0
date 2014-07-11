From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: uas - kernel panic on drive connection
Date: Fri, 11 Jul 2014 11:36:28 +0200
Message-ID: <53BFB01C.6020900@redhat.com>
References: <20140704104028.2014aaf4@earthlink.net>	<53BCEA03.30304@redhat.com> <20140709193139.32049945@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbaGKJgc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 05:36:32 -0400
In-Reply-To: <20140709193139.32049945@earthlink.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan <jonathan.625266@earthlink.net>, linux-scsi@vger.kernel.org

Hi,

On 07/10/2014 01:31 AM, Jonathan wrote:
> Hans,
> 
> Thanks for getting back to me. It looks like the USB 3.0 controller is an Etron.

Etron, that is the first time I've heard of them. So that is the 5th manufacturer
which is making xhci controllers now (the others are nec, intel, via and designware).

I've managed to find a pci-e add-on card using the same Etron chipset as you have,
and I've ordered one, so that I can try and reproduce this problem. It will be
aprox. 3 weeks before I get it though.

In the mean time, can you try the usb disk enclosure on a machine with a nec or
intel xhci controller ? So that we can confirm that this is indeed a problem
specific to the Etron controller?

Regards,

Hans


> 
> Here is the output from lspci:
> 
> 00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)
> 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09)
> 00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
> 00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
> 00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
> 00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
> 00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b5)
> 00:1c.4 PCI bridge: Intel Corporation 82801 PCI Bridge (rev b5)
> 00:1c.5 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 6 (rev b5)
> 00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
> 00:1f.0 ISA bridge: Intel Corporation Z68 Express Chipset Family LPC Controller (rev 05)
> 00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family SATA AHCI Controller (rev 05)
> 00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
> 01:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
> 02:00.0 USB controller: Etron Technology, Inc. EJ168 USB 3.0 Host Controller (rev 01)
> 03:00.0 PCI bridge: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge (rev 01)
> 04:00.0 FireWire (IEEE 1394): Texas Instruments TSB12LV26 IEEE-1394 Controller (Link)
> 05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
> 
> Best,
> 
> Jonathan
> 
> On Wed, 09 Jul 2014 09:06:43 +0200
> Hans de Goede <hdegoede@redhat.com> wrote:
> 
>>
>> This looks like something is going wrong in the XHCI code, likely something
>> related to bulk-streams.
>>
>> I've a dock with an ASMedia ASM1053E chipset myself and that one works fine with both
>> Nec and Intel XHCI controllers. What type of XHCI controller do you have ?
>>
>> Can you please do "lspci" on the machine in question and include the output in your
>> next mail ?
>>
>> Regards,
>>
>> Hans
