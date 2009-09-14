From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14159] AIC79xx is not working properly with an attached scsi
 tape since 2.6.29
Date: Mon, 14 Sep 2009 07:18:48 GMT
Message-ID: <200909140718.n8E7ImIE010519@demeter.kernel.org>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35739 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZINHSp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 03:18:45 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8E7ImQ4010520
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2009 07:18:48 GMT
In-Reply-To: <bug-14159-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14159





--- Comment #3 from g.giorgetti@teamsystem.com  2009-09-14 07:18:46 ---
Hi James,

today after building and installing the latest stable kernel 2.6.31 I can tell
you that the problem is still there.

Here is the machine's /proc/interrups

           CPU0       CPU1       
  0:         44          0   IO-APIC-edge      timer
  1:          0          2   IO-APIC-edge      i8042
  3:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, ohci_hcd:usb5,
ohci_hcd:usb6
  4:          0          2   IO-APIC-edge    
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi, sata_svw
 12:          0          4   IO-APIC-edge      i8042
 14:         63      92631   IO-APIC-edge      ide0
 19:          0          0   IO-APIC-fasteoi   aic79xx
 20:        876    5417561   IO-APIC-fasteoi   eth0
 21:          0         29   IO-APIC-fasteoi   ehci_hcd:usb1, ohci_hcd:usb3,
ohci_hcd:usb4
 22:        268     827272   IO-APIC-fasteoi   aacraid
NMI:          0          0   Non-maskable interrupts
LOC:    3340059    3367236   Local timer interrupts
SPU:          0          0   Spurious interrupts
CNT:          0          0   Performance counter interrupts
PND:          0          0   Performance pending work
RES:     132590      57223   Rescheduling interrupts
CAL:         80         64   Function call interrupts
TLB:       8153       6593   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
MCE:          0          0   Machine check exceptions
MCP:         40         40   Machine check polls
ERR:          0
MIS:          0

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
