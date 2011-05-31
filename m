From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: 2.6.39 kernel panic w/screenshots & kernel cfg link provided
Date: Tue, 31 May 2011 22:31:12 +0800
Message-ID: <4DE4FBB0.9080708@fnarfbargle.com>
References: <alpine.DEB.2.02.1105280755050.4345@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fnarfbargle.com ([93.93.131.224]:33598 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753443Ab1EaOyu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 10:54:50 -0400
In-Reply-To: <alpine.DEB.2.02.1105280755050.4345@p34.internal.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 28/05/11 20:01, Justin Piszcz wrote:
> Hello,
>
> Since I updated to 2.6.39, my system has been crashing on a random
> basis, can someone identify what is going on here?
>
> I've checked the hardware it is OK and this only started to occur after
> I moved to 2.6.39 from what I can tell..
>
> Kernel crash/panic, hang:
> http://home.comcast.net/~jpiszcz/20110528/2639-ss1.jpg
> http://home.comcast.net/~jpiszcz/20110528/2639-ss2.jpg
>
> Kernel .config:
> http://home.comcast.net/~jpiszcz/20110528/config-2.6.39.txt

Just a me too I'm afraid.
On a 2.6.39 kernel I get these from about 3 of 4 boots.
If I append "panic=30" to the command line and leave it go, eventually I 
get into a working kernel.

I've seen them on a 2.6.38.7 kernel also, but far harder to hit and I've 
not seen them at all on a 2.6.38.2 kernel.

Once the kernel is running I don't seem to have an issue.

brad@srv:~$ lspci
00:00.0 Host bridge: Advanced Micro Devices [AMD] RS880 Host Bridge
00:01.0 PCI bridge: ASRock Incorporation Device 9602
00:02.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(ext gfx port 0)
00:03.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(ext gfx port 1)
00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(PCIE port 0)
00:09.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(PCIE port 4)
00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge 
(PCIE port 5)
00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA 
Controller [AHCI mode] (rev 40)
00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 41)
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA) (rev 40)
00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller 
(rev 40)
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (rev 40)
00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 
Controller
00:16.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 
Controller
00:16.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
HyperTransport Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor 
Link Control
01:05.0 VGA compatible controller: ATI Technologies Inc RS880 [Radeon HD 
4250]
02:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host 
Controller (rev 03)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 06)
04:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 9240 
(rev 02)
05:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 9240 
(rev 02)
07:00.0 SCSI storage controller: Marvell Technology Group Ltd. 88SX7042 
PCI-e 4-port SATA-II (rev 02)
