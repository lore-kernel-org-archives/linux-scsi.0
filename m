From: jurek Ela Tryjarscy <jurekt@kabatnet.waw.pl>
Subject: Problem - install scsi adapter and scanner
Date: Tue, 05 Oct 2004 18:14:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4162C868.4010902@kabatnet.waw.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from susy.kabatnet.waw.pl ([212.244.31.2]:11524 "HELO
	kabatnet.waw.pl") by vger.kernel.org with SMTP id S270448AbUJEQOo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 12:14:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi ,
In my box I have Redhat 9.
I must connect via SCSI Interface Umax Mirage II scanner.
SCSI adapter is Acard AEC-6712TU.

System logs contain:

Oct  4 19:19:05 localhost kernel:    ACARD AEC-671X PCI Ultra/W SCSI-3 
Host Adapter: 0    IO:1000, IRQ:11.
Oct  4 19:19:05 localhost kernel:          ID:  7  Host Adapter
Oct  4 19:19:05 localhost kernel: scsi0 : ACARD AEC-6710/6712/67160 PCI 
Ultra/W/LVD SCSI-3 Adapter Driver V2.6+ac

information.

Driver is atp870u.

My qustion is:
How to install correctly the scanner and the scsi adapter - I must make 
any mistake.
I do:
modprobe sg
modprobe atp870u

[root@localhost scsi]# lsmod
Module                  Size  Used by    Not tainted
atp870u                23856   0  (unused)
sg                     36524   0  (unused)
scsi_mod              107160   2  [atp870u sg]
ide-cd                 35676   0  (autoclean)
cdrom                  33728   0  (autoclean) [ide-cd]
parport_pc             19076   1  (autoclean)
lp                      8996   0  (autoclean)
parport                37056   1  (autoclean) [parport_pc lp]
autofs                 13268   0  (autoclean) (unused)
8139too                18120   1
mii                     3976   0  [8139too]
keybdev                 2976   0  (unused)
mousedev                5492   1
hid                    22148   0  (unused)
input                   5888   0  [keybdev mousedev hid]
usb-uhci               26348   0  (unused)
usbcore                78816   1  [hid usb-uhci]
ext3                   70784   2
jbd                    51892   2  [ext3]

[root@localhost root]# ls  /proc/scsi
atp870u  scsi

[root@localhost scsi]# more  scsi
Attached devices: none

I think it should be also sg directory in  /proc/scsi

[root@localhost root]# sane-find-scanner

 # No SCSI scanners found. If you expected something different, make 
sure that
 # you have loaded a SCSI driver for your SCSI adapter.
 # Also you need support for SCSI Generic (sg) in your operating system.
 # If using Linux, try "modprobe sg".

Can anyone help me ?

Jurek

