From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11404] BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Thu, 23 Oct 2008 13:51:20 -0700 (PDT)
Message-ID: <20081023205120.86786108056@picon.linux-foundation.org>
References: <bug-11404-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbYJWUvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2008 16:51:55 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9NKpKYY032028
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2008 13:51:21 -0700
In-Reply-To: <bug-11404-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11404





------- Comment #3 from randy.dunlap@oracle.com  2008-10-23 13:51 -------
System is an HP Blade, dual x86_64 (AMD) with hyperthreading, 8 GB RAM,
nVidia CK804 chipset.  The storage controller is this:

42:08.0 RAID bus controller: Hewlett-Packard Company Unknown device 3238
        Subsystem: Hewlett-Packard Company Unknown device 3211
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 120
        Interrupt: pin A routed to IRQ 87
        Region 0: Memory at fdf80000 (64-bit, non-prefetchable) [size=512K]
        Region 2: I/O ports at 4000 [size=256]
        Region 3: Memory at fdf70000 (32-bit, non-prefetchable) [size=32K]
        [virtual] Expansion ROM at 84000000 [disabled] [size=16K]
        Capabilities: [c0] Power Management version 2 
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [cc] Message Signalled Interrupts: 64bit+ Queue=0/1
Enable+
                Address: 00000000fee0200c  Data: 41b9
        Capabilities: [dc] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=512 OST=1
                Status: Dev=42:08.0 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=4096 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-

The problem just happened again on 2.6.27-git10.
The kernel boot log & config file for this are at:
http://oss.oracle.com/~rdunlap/kerneltest/logs/cciss/
along with lots of /proc files & lspci etc. from a good boot.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
