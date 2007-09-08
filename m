From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8989] New: LSIFC909 card don't recognice any
 more my FC drives
Date: Fri, 7 Sep 2007 21:49:02 -0700
Message-ID: <20070907214902.ed22eff9.akpm@linux-foundation.org>
References: <bug-8989-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbXIHEtJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Sep 2007 00:49:09 -0400
In-Reply-To: <bug-8989-10286@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: bugme-daemon@bugzilla.kernel.org, pfammatter-egi@hispeed.ch

On Fri,  7 Sep 2007 05:42:12 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8989
> 
>            Summary: LSIFC909 card don't recognice any more my FC drives
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.18
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: pfammatter-egi@hispeed.ch
> 
> 
> Hello,
> 
> I had upgraded my server from debian sarge (kernel 2.6.8) to debian etch
> (kernel 2.6.18).
> Since this upgrade I can't any more see my fc-drives. I get no failures
> during the system boot.
> It seems that the card would be reginized correct, but as I wrote, I
> can't see any drives.
> When I boot the server with debian sarge (kernel 2.6.8) all works
> fine ..;-)
> I had compile a new kernel 2.6.22.6 also with MPT- direct compiled into
> the kernel (not as moduls) and tries with them also.. but no success.
> 
> Here is my config:
> HBA: LSIFC909
> Disk: 1 x SEGATE CHEETAH 18 GB 10Krpm + 2 x HITACHI 146GB 15Krpm drives
> in AL (works fine with kernel 2.6.8...)
> 
> I send you here any logs:
> lspci:
> 00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM
> Controller/Host-Hub Interface (rev 02)
> 00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller
> (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB
> UHCI Controller #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2
> EHCI Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
> 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC
> Interface Bridge (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE
> Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus
> Controller (rev 02)
> 01:00.0 VGA compatible controller: nVidia Corporation NV20 [GeForce3 Ti
> 500] (rev a3)
> 02:02.0 SCSI storage controller: LSI Logic / Symbios Logic FC909 Fibre
> Channel Adapter (rev 01)
> 02:04.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev
> 0a)
> 02:04.1 Input device controller: Creative Labs SB Live! Game Port (rev
> 0a)
> 02:08.0 Ethernet controller: Intel Corporation 82562EZ 10/100 Ethernet
> Controller (rev 02)
> 
> /var/log/messages: (debuging enabled
> in /usr/src/linux/drivers/message/fusion/Makefile: EXTRA_CFLAGS +=
> -DMPT_DEBUG_INIT)
> 
> ..
> Sep  6 09:47:10 localhost kernel: Copyright (c) 1999-2005 LSI Logic
> Corporation
> Sep  6 09:49:22 localhost kernel: mptscsih: Unknown symbol
> scsi_remove_host
> Sep  6 09:49:22 localhost kernel: mptscsih: Unknown symbol scsi_host_put
> Sep  6 09:49:22 localhost kernel: mptscsih: Unknown symbol
> scsi_print_command
> Sep  6 09:49:22 localhost kernel: mptscsih: Unknown symbol
> scsi_adjust_queue_depth
> Sep  6 09:50:09 localhost kernel: SCSI subsystem initialized
> Sep  6 09:50:53 localhost kernel: mptfc: Unknown symbol
> fc_attach_transport
> Sep  6 09:50:53 localhost kernel: mptfc: Unknown symbol
> fc_remote_port_add
> Sep  6 09:50:53 localhost kernel: mptfc: Unknown symbol fc_remove_host
> Sep  6 09:50:53 localhost kernel: mptfc: Unknown symbol
> fc_remote_port_delete
> Sep  6 09:50:53 localhost kernel: mptfc: Unknown symbol
> fc_release_transport
> Sep  6 09:50:53 localhost kernel: mptfc: Unknown symbol
> fc_remote_port_rolechg
> Sep  6 09:50:53 localhost kernel: mptfc: Unknown symbol scsi_is_fc_rport
> Sep  6 09:51:28 localhost kernel: Fusion MPT misc device (ioctl) driver
> 3.04.01
> Sep  6 09:51:28 localhost kernel: mptctl: Registered with Fusion MPT
> base driver
> Sep  6 09:51:28 localhost kernel: mptctl: /dev/mptctl @
> (major,minor=10,220)
> Sep  6 09:52:08 localhost kernel: Fusion MPT FC Host driver 3.04.01
> Sep  6 09:52:08 localhost kernel: mptbase: Initiating ioc0 bringup
> Sep  6 09:52:09 localhost kernel: scsi0 : ioc0: LSIFC909,
> FwRev=01000000h, Ports=1, MaxQ=1023, IRQ=201
> Sep  6 09:54:37 localhost mpt-statusd: detected non-optimal RAID status
> 
> 
> loaded modules:
> mptfc                  14468  0
> mptscsih               21696  1 mptfc
> mptbase                46176  2 mptfc,mptscsih
> scsi_transport_fc      28544  1 mptfc
> scsi_mod              124168  3 mptfc,mptscsih,scsi_transport_fc
> 
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
