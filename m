From: Ric Wheeler <ric@emc.com>
Subject: impact of 4k sector size on the IO & FS stack
Date: Sun, 11 Mar 2007 18:51:53 -0400
Message-ID: <45F48809.2060908@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


During the recent IO/FS workshop, we spoke briefly about the coming 
change to a 4k sector size for disks on linux. If I recall correctly, 
the general feeling was that the impact was not significant since we 
already do most file system IO in 4k page sizes and should be fine as 
long as we partition drives correctly and avoid non-4k aligned partitions.

Are there other concerns in the IO or FS stack that we should bring up 
with vendors?  I have been asked to summarize the impact of 4k sectors 
on linux  for a disk vendor gathering and want to make sure that I put 
all of our linux specific items into that summary...

ric


