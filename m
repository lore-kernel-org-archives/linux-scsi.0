From: Asdo <asdo@shiftmail.org>
Subject: Internal controllers for md-raid
Date: Tue, 02 Mar 2010 19:11:29 +0100
Message-ID: <4B8D54D1.3010000@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,
excuse me if I resurrect this topic again.

We need to buy some controllers for internal RAID (=same chassis as the 
mainboard) with lots of ports: at least 16.

Would be for MD RAID use (no HW raid).

We have WD RE3 SATA drives, so SAS is not necessary. BTW the differences 
between SATA and SAS are not yet that clear to me especially for 
internal arrays i.e. no expanders.

The driver should be in the mainstream kernel otherwise upgrading or 
using a new kernel is a pain. This seems to exclude all new LSI 
controllers, which have been suggested on this linux-raid ML: by 
grepping the 2.6.33 sources it seems I can't find drivers for LSI 84016E 
16internal ports, nor for the LSI SAS 9200-8e which was suggested in 
this ML.

@ people using LSI SAS cards: how can you use the latest kernel? Latest 
driver I see at the website is for RHEL5 and SLES10 so would be 2.6.16. 
You are forced to use such an old kernel?

We also need hot-swap, or "warm" swap whatever... I mean it's OK to type 
commands at the console but we mustn't need to reboot the machine to see 
new drives.

Looking around I have found the following controllers:

    Areca ARC-1680ix-24 - (24int + 4 ext) - $1130
    Areca ARC-1300ix-16  (16int + 4ext) - $330
    Areca ARC-1280ML (24int) - (probably surpassed by the 1680ix) - $1100
    Adaptec 51645 - (16int + 4ext) - $800
    Intel SRCSASPH16I  (16int) - $630
    3ware 9650SE  -16ML or -24M8: $850 or $1000

3wares 9650SE we already have them: they are stable but it seems to me 
that they are slow, especially for random I/O.

The Areca ARC-1300ix-16 is very cheap but I read of big troubles with 
that card or the  using the same Marvell chipset. I think there is a 
discussion still going in linux-scsi. I'll try to follow there.

For the Intel SRCSASPH16I card I don't see the driver mentioned 
explicitly in the kernel sources. The card uses two LSI SAS1068 
controllers for which I do see the driver in the kernel souces but I 
don't know if this is enough to support the Intel card at least as an 
HBA (no HW RAID). Linux-scsi people do you know?

Regarding the Areca Adaptec cards (except the 1300ix), anybody having 
any experience with these brands can comment on stability and speed on 
linux MD raid?

Thanks for your suggestions
Asdo
