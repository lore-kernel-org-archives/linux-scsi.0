From: "bj rui" <bj_rui@hotmail.com>
Subject: mdadm output -- please explain
Date: Fri, 25 Mar 2005 16:43:25 +0000
Message-ID: <BAY17-F241AF7FA27B168CABE8931F6410@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Received: from bay17-f24.bay17.hotmail.com ([64.4.43.74]:36126 "EHLO
	hotmail.com") by vger.kernel.org with ESMTP id S261237AbVCYQn1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2005 11:43:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

as far as i know, there are only 6 devices in this array, yet i
see 'Total Devices : 7'

i also see a failed devices, yet at the bottom, none of the devices
are marked as faulty.

here's the pertinent line from /proc/mdstat:
md0 : active raid5 sdp[5] sdo[4] sdn[3] sdm[2] sdj[1] sdi[0]
      716872960 blocks level 5, 128k chunk, algorithm 2 [6/6] [UUUUUU]

i'm not having any problems with the array, this just wasn't what i expected
to see.  could someone please explain?

-rui

#> mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Mon Mar 21 16:59:41 2005
     Raid Level : raid5
     Array Size : 716872960 (683.66 GiB 734.08 GB)
    Device Size : 143374592 (136.73 GiB 146.82 GB)
   Raid Devices : 6
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Mar 22 07:55:58 2005
          State : dirty, no-errors
Active Devices : 6
Working Devices : 6
Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8      128        0      active sync   /dev/sdi
       1       8      144        1      active sync   /dev/sdj
       2       8      192        2      active sync   /dev/sdm
       3       8      208        3      active sync   /dev/sdn
       4       8      224        4      active sync   /dev/sdo
       5       8      240        5      active sync   /dev/sdp
           UUID : 0dd747ec:22a09ffb:debe6f31:78f4c769
         Events : 0.4


