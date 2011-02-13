From: John Reynolds <bigjohn067@gmail.com>
Subject: scsi_mod issue
Date: Sun, 13 Feb 2011 14:07:05 +0000
Message-ID: <AANLkTikyGMHeE-k8J=j7axdjzcJKoHedOLfk3YuK7N5_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59176 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1BMOHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2011 09:07:07 -0500
Received: by iwn9 with SMTP id 9so3966181iwn.19
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2011 06:07:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

we are trying to get the iSCSI Initiator running on SLES 10 SP3 XEN

Kernel 2.6.16.60-0.54.5-xen #1 SMP
module-init-tools version 3.2.2


the initiator connects and logs in to the target (SLES10SP3).
but doesnt make the device node, the dmesg output is :-
scsi4 : iSCSI Initiator over TCP/IP
 4:0:0:0: scsi scan: consider passing
scsi_mod.dev_flags=IET:VIRTUAL-DISK:0x240 or 0x1000240

in the syslog :-
Feb 13 14:07:37 POS2-HOST kernel: scsi4 : iSCSI Initiator over TCP/IP
Feb 13 14:07:37 POS2-HOST kernel:  4:0:0:0: scsi scan: consider
passing scsi_mod.dev_flags=IET:VIRTUAL-DISK:0x240 or 0x1000240
Feb 13 14:07:37 POS2-HOST iscsid: connection4:0 is operational now

it would appear the scsi module does recognise the vendor and module
as a scsi block device.
I have tried adding the following lines to /etc/modprobe.conf.local
options scsi_mod dev_flags="IET:VIRTUAL-DISK:0x240"
or
options scsi_mod dev_flags="IET:VIRTUAL-DISK:0x1000240"

rebooted several times, with the same error message
even added the scsi_mod.dev_flags=IET:VIRTUAL-DISK:0x240 to the kernel
boot options, again the same error.

Anyone have any suggestions or ideas ?

John
