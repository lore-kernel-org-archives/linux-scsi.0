From: Douglas Gilbert <dougg@torque.net>
Subject: sysfs mount point permissions in 2.5.64
Date: Thu, 06 Mar 2003 08:47:20 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E667068.4000204@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

In lk 2.5.64 on my i386 box the sysfs mount point
( "/sys") changes permission from:
   drwxr-xr-x
to
   drw-r--r--
during the boot process. I didn't notice this feature
in lk 2.5.63 . Chmodding the directory back to its former
permissions get overridden by subsequent boot sequences.

This change in permissions inhibits non-root users from using
utilities that scan sysfs for information (e.g. lsscsi).

Is this a feature or otherwise?

Doug Gilbert

