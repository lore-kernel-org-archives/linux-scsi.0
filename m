From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
Date: Fri, 27 Aug 2010 09:12:04 -0400 (EDT)
Message-ID: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I sometimes see this on one of my two 3ware cards in my system.

I have opened a case previously with LSI/3ware and they are not sure what 
is going on, all disks are good, etc.

I notice this sometimes occurs when there is high I/O & network activity, 
but I am not able to reproduce it at will.  I do remember it happening 
before though just running a postmap on some files and rsyncing a few 
configuration files around.

Originally I thought it might be something to do with having smartd 
running, but I disabled it and the problem persists.

The next thing I am looking at is the 'nobarrier' option, I've always used 
it in the past, I have now mounted all FS without it and I will see if the 
error recurs.

Does anyone know what the root cause of this problem may be?

Aug 24 09:14:04 p34 kernel: [247295.662461] 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.

Latest kernel (2.6.35.x) and latest firmware on the card, etc.

Justin.
