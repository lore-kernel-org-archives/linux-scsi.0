From: "Felipe Alfaro Solana" <felipe_alfaro@msn.com>
Subject: cdrecord, IDE-SCSI and 2.5.39
Date: Mon, 30 Sep 2002 17:55:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <F758Ts6DdVjkfQWswop000122ba@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I have found that cdrecord 1.11a34 has stopped working on linux kernel 
2.5.38+. I have a SONY CRX185E3 ATAPI burner and it works fine on 2.4.19 
using "hdd=ide-scsi" kernel parameter, but with kernel 2.5.38+, cdrecord 
fails when trying to access the "/dev/pg*" device files. When I run cdrecord 
-scanbus, it complains with:

cdrecord: No such file or directory. Cannot open '/dev/pg*'. Cannot open 
SCSI driver.

I'm logged on as root. SCSI support is enabled as loadable modules (both the 
IDE-SCSI and SCSI generic support), as well as IDE CD-ROM. The "sg.o", 
"ide-scsi.o" and "scsi_mod.o" modules are loaded and I have used the 
"hdd=ide-scsi" kernel parameter. Also, on /var/log/messages, an entry 
reports problem locating char-major-97. I have a QDI Platinix P4 Motherboard 
with Intel 845 chipset.

Is this a known issue? Also, when running 2.5.38+, why is my computer's box 
IDE led activity continuously lit? On 2.4.19, it only lits when there is 
disk/CD-ROM activity, but on 2.5.38+ it's kept always lit...

Sincerely,

   Felipe Alfaro

_________________________________________________________________
Send and receive Hotmail on your mobile device: http://mobile.msn.com
