From: Jeff Hill <jhill@hrpost.com>
Subject: Whenever two drives plugged in, second drive fails?
Date: Thu, 20 Jun 2002 14:15:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20020620131337.023d8d40@205.233.215.4>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyberia_laptop.hrpost.com ([65.95.96.189])
          by tomts12-srv.bellnexxia.net
          (InterMail vM.5.01.04.19 201-253-122-122-119-20020516) with ESMTP
          id <20020620181544.KWDP2688.tomts12-srv.bellnexxia.net@cyberia_laptop.hrpost.com>
          for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2002 14:15:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A bit of a problem that appears to be more complex than I thought:

When I try to add a recently repaired drive to my SCSI chain, the Adaptec 
2940U2W controller  times out trying to find it, even reports occasionally 
a "cable or termination error, please fix."

Sounds simple, but I don't think it's termination on the drives, since 
they're an identical pair of Seagate Cheetah LVD drives.

  The LVD cable is an expensive custom, teflon job with active termination, 
but I decided to try using my spare LVD cable, the original from Adaptec. 
Same result. I've also tried changing the order of the drives, but there is 
little difference: when the repaired drive is the first one in the chain, 
the controller just seems to freeze up faster.

My old SCSI drive works fine alone on the cable as sda: the  controller 
recognizes it without any problem and sda boots up as the first drive in a 
software RAID-1 where sda is the only drive in the array (I was waiting for 
the repaired drive [which came out of another system] to return).

I started to suspect it was some fault with the repaired drive. After 
trying a number of tests, I finally put it on the scsi cable by itself, 
booting the system off an IDE drive. In this configuration, the drive is 
recognized with no problem. I partitioned it, did a bad block check, put 
some ext2 file systems on it, did some further testing, couldn't find any 
problem with the repaired drive.

Then I thought maybe it was a power issue, so I unplugged the IDE drives 
and CD-ROM to make certain that wasn't it (even though I have a pretty good 
300Watt power supply). No change.

Any suggestions on what else to try would be appreciated.

Regards,

Jeff Hill



----
Jeff Hill
www.HRpost.com
Ph: 416-047251
Fx: 647-439-1414
----


