From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 00:14:43 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703120013340.18623@yvahk01.tjqt.qr>
References: <45F48809.2060908@emc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <45F48809.2060908@emc.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Mar 11 2007 18:51, Ric Wheeler wrote:
>
> During the recent IO/FS workshop, we spoke briefly about the
> coming change to a 4k sector size for disks on linux. If I
> recall correctly, the general feeling was that the impact was
> not significant since we already do most file system IO in 4k
> page sizes and should be fine as long as we partition drives
> correctly and avoid non-4k aligned partitions.

Sorry about jumping right in, but what about an 'old-style'
partition table that relies on 512 as a unit?

> Are there other concerns in the IO or FS stack that we should
> bring up with vendors?  I have been asked to summarize the
> impact of 4k sectors on linux for a disk vendor gathering and
> want to make sure that I put all of our linux specific items
> into that summary...

Jan
-- 
