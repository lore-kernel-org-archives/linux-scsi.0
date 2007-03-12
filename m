From: Douglas Gilbert <dougg@torque.net>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 15:16:07 -0400
Message-ID: <45F5A6F7.9080108@torque.net>
References: <OFCF49F323.33FDF27D-ON8825729C.0064FD4B-8825729C.0065C420@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <OFCF49F323.33FDF27D-ON8825729C.0064FD4B-8825729C.0065C420@us.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ric Wheeler <ric@emc.com>
List-Id: linux-scsi@vger.kernel.org

Bryan Henderson wrote:
>> DOS partitions start partitions on odd-numbered sectors
> 
> I don't get this.  If you mean partitions defined by the classic DOS 
> partition table format, then AFAICS, such a partition can start in any 
> sector.

Bryan,
Typically the first partition on a DOS partitioned disk
starts at the next available sector after the mbr
which, for some bizarre reason, is 63 sectors long.
Hence:

# fdisk -lu /dev/hda

Disk /dev/hda: 80.0 GB, 80026361856 bytes
255 heads, 63 sectors/track, 9729 cylinders, total 156301488 sectors
Units = sectors of 1 * 512 = 512 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *          63    18314099     9157018+   c  W95 FAT32 (LBA)
/dev/hda2        18314100    19551104      618502+  82  Linux swap / Solaris
/dev/hda4        19551105   156296384    68372640   83  Linux


> 
>> so presuming you have odd-aligned disks, life is good.
> 
> What is an odd-aligned disk?

s/disk/partition/ ?
Perhaps hda1 and hda4 above are examples.

Doug Gilbert

