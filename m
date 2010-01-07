From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15001] New: megaraid_sas fills dmesg with megasas: Failed to
 copy out to user sense data
Date: Thu, 7 Jan 2010 12:42:04 GMT
Message-ID: <bug-15001-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37051 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0AGMmF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2010 07:42:05 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o07Cg4L2000984
	for <linux-scsi@vger.kernel.org>; Thu, 7 Jan 2010 12:42:04 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15001

           Summary: megaraid_sas fills dmesg with megasas: Failed to copy
                    out to user sense data
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.31.8 2.6.31.9 2.6.31.10
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: mailatgoogl@gmail.com
        Regression: Yes


starting from 2.6.31.8 megaraid_sas driver fills dmesg with 

megasas: Failed to copy out to user sense data


I donwloaded and build megaraid_sas from dell site :  megaraid_sas-v00.00.04.17

but without any result , I still get this messages .

on 2.6.31.7 it worked just fine .


uname -a
Linux myhost 2.6.31.10-grsec #1 SMP Thu Jan 7 11:13:42 CET 2010 x86_64
GNU/Linux


 modinfo megaraid_sas
filename:      
/lib/modules/2.6.31.10-grsec/kernel/drivers/scsi/megaraid/megaraid_sas.ko
description:    LSI MegaRAID SAS Driver
author:         megaraidlinux@lsi.com
version:        00.00.04.01
license:        GPL
srcversion:     78C40B2F67D5AE7885571F9
alias:          pci:v00001028d00000015sv*sd*bc*sc*i*
alias:          pci:v00001000d00000413sv*sd*bc*sc*i*
alias:          pci:v00001000d00000079sv*sd*bc*sc*i*
alias:          pci:v00001000d00000078sv*sd*bc*sc*i*
alias:          pci:v00001000d0000007Csv*sd*bc*sc*i*
alias:          pci:v00001000d00000060sv*sd*bc*sc*i*
alias:          pci:v00001000d00000411sv*sd*bc*sc*i*
depends:        scsi_mod
vermagic:       2.6.31.10-grsec SMP mod_unload modversions 
parm:           poll_mode_io:Complete cmds from IO path, (default=0) (int)


#lspci
00:00.0 Host bridge: Intel Corporation QuickPath Architecture I/O Hub to ESI
Port (rev 13)
00:01.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI
Express Root Port 1 (rev 13)
00:03.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI
Express Root Port 3 (rev 13)
00:04.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI
Express Root Port 4 (rev 13)
00:05.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI
Express Root Port 5 (rev 13)
00:06.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI
Express Root Port 6 (rev 13)
00:07.0 PCI bridge: Intel Corporation QuickPath Architecture I/O Hub PCI
Express Root Port 7 (rev 13)
00:14.0 PIC: Intel Corporation QuickPath Architecture I/O Hub System Management
Registers (rev 13)
00:14.1 PIC: Intel Corporation QuickPath Architecture I/O Hub GPIO and Scratch
Pad Registers (rev 13)
00:14.2 PIC: Intel Corporation QuickPath Architecture I/O Hub Control Status
and RAS Registers (rev 13)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #2 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #2 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IB (ICH9) LPC Interface Controller
(rev 02)
00:1f.2 IDE interface: Intel Corporation 82801IB (ICH9) 2 port SATA IDE
Controller (rev 02)
01:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit
Ethernet (rev 20)
01:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit
Ethernet (rev 20)
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit
Ethernet (rev 20)
02:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit
Ethernet (rev 20)
03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev
04)
04:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to PCI
Express HBA (rev 03)
04:00.1 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to PCI
Express HBA (rev 03)
07:03.0 VGA compatible controller: Matrox Graphics, Inc. MGA G200eW WPCM450
[Hermon] - Winbond/Nuvoton (rev 0a)

Please tell me if you need any additional information .
thank you , 
Alex

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
