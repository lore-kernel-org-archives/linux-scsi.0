From: Matthew Schumacher <matt.s@aptalaska.net>
Subject: new kernel = megaraid performance cut in half
Date: Tue, 14 May 2002 00:55:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CE0D0F4.3000601@aptalaska.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have a dell server that has a perc 3 DCL (megaraid) controller in it 
running redhat 7.2.  I was using the default kernel but I decided to 
upgrade to 2.4.18 to get the new VM code and for some quota fixes. 
Anyway, I compiled the kernel and the machine boots fine but my disk 
speed cut in half.

Is there anything I can do to resolve the speed issue so that I can 
continue using the 2.4.18 kernel?  This box is serving mail so 21MB sec 
on 3x10000rpm scsi3 disks in a raid 5 array is not acceptable.

Thanks for the help,

schu


[root@mail_test linux]# uname -a
Linux mail_test 2.4.18 #1 SMP Mon May 13 18:39:45 AKDT 2002 i686 unknown
[root@mail_test linux]# hdparm -t /dev/sda

/dev/sda:
  Timing buffered disk reads:  64 MB in  3.04 seconds = 21.05 MB/sec


Where on the default redhat kernel I get:

[root@mail_test root]# uname -a
Linux mail_test 2.4.7-10smp #1 SMP Thu Sep 6 17:09:31 EDT 2001 i686 unknown
[root@mail_test root]# hdparm -t /dev/sda

/dev/sda:
  Timing buffered disk reads:  64 MB in  1.71 seconds = 37.43 MB/sec

