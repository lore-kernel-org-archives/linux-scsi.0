From: Douglas Gilbert <dougg@torque.net>
Subject: Fwd: 32bit dev_t
Date: Wed, 22 Jan 2003 08:56:45 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E2DC21D.9010204@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sdake@mvista.com, Joel.Becker@oracle.com

This post appeared recently on the linux kernel list.
What is the maximum number of disks that can be attached
in lk 2.5? Is it 256 (double the number of SCSI disk majors)
or larger. I remember Richard Gooch's "sd-many" patch
was rejected for 2.5 because it was said there was a
better mechanism around the corner.

BTW when I tested 129 (1 real + 128 dummies) disks with
scsi_debug there was a problem the last one. Has anyone
tested > 128 disks in lk 2.5?

Doug Gilbert


Steven Dake wrote:
 >
 > Joel,
 >
 > Linux doesn't really need a 32 bit kdev_t structure to support 1000
 > disks.  There is plenty of device space available to support over 1500
 > disks by modifying the linux scsi layer.
 >
 > Thanks
 > -steve
 >
 > Joel Becker wrote:
 >
 > >Folks,
 > >	Who is tracking the 32bit dev_t effort for 2.5?  There are
 > >already existing installations with 500 to 1000 disks attached to a
 > >system, and I don't know that Linux really wants to wait four
 > >years to get there!
 > >	If someone could point me to a current patch or any current
 > >information about the issues, I'd really appreciate it.
 > >
 > >Joel

