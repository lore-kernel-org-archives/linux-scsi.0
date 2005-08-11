From: Ming Zhang <mingz@ele.uri.edu>
Subject: hwo to adjust interrupt?
Date: Thu, 11 Aug 2005 18:31:08 -0400
Message-ID: <1123799468.5546.81.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:63362 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S932500AbVHKWbN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 18:31:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I have this eth1 and aic7xxx share 1 interrupt thus have impact on
performance, anyway i can change it? thx!


[root@sc420 root]# cat /proc/interrupts
           CPU0       CPU1
  0:     378525     402791    IO-APIC-edge  timer
  1:         38         26    IO-APIC-edge  i8042
  4:          7          0    IO-APIC-edge  serial
  8:          3          2    IO-APIC-edge  rtc
  9:          0          0   IO-APIC-level  acpi
 14:       2325        932    IO-APIC-edge  ide0
 16:    1330261          0   IO-APIC-level  eth1, aic7xxx
 17:       2917          8   IO-APIC-level  aic7xxx
 18:          3          0   IO-APIC-level  uhci_hcd:usb4
 20:       7577       6597   IO-APIC-level  libata
 21:          0          0   IO-APIC-level  ehci_hcd:usb1, uhci_hcd:usb2
 22:          0          0   IO-APIC-level  uhci_hcd:usb3
 23:          0          0   IO-APIC-level  uhci_hcd:usb5
NMI:    2017738    1165555
LOC:     781237     781288
ERR:          0
MIS:          0



