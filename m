From: Mukul Kotwani <mkotwani@yahoo.com>
Subject: Maximum  disks
Date: Wed, 31 Jul 2002 16:34:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020731233404.87984.qmail@web14005.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!
Had a question:
If I have more than 8 disks connected, I dont see more
than 8 at any time. The /proc/partitions shows all 16
, but if I look in /dev/sd*, I see /dev/sda1-15,
/dev/sdb1-15 and upto /dev/sdh1-15. But the
/proc/partitons shows sdi1, sdj1.. as partitions,
which are not listed in /dev/ at all.
I am not using devfs, and cannot use it because of
certain reasons. So without using devfs, is there a
way to see more 8 disks at all? The /dev directory
seems to have /dev/sda1-15 to /dev/sdh1-15 pre created
even if I have nothing connected. 

Thanks in advance!
M

__________________________________________________
Do You Yahoo!?
Yahoo! Health - Feel better, live better
http://health.yahoo.com
