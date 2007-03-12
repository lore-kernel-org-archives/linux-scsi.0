From: Ric Wheeler <ric@emc.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Sun, 11 Mar 2007 22:45:24 -0400
Message-ID: <45F4BEC4.5090402@emc.com>
References: <45F48809.2060908@emc.com> <Pine.LNX.4.61.0703120013340.18623@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703120013340.18623@yvahk01.tjqt.qr>
Sender: linux-ide-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



Jan Engelhardt wrote:
> On Mar 11 2007 18:51, Ric Wheeler wrote:
>   
>> During the recent IO/FS workshop, we spoke briefly about the
>> coming change to a 4k sector size for disks on linux. If I
>> recall correctly, the general feeling was that the impact was
>> not significant since we already do most file system IO in 4k
>> page sizes and should be fine as long as we partition drives
>> correctly and avoid non-4k aligned partitions.
>>     
>
> Sorry about jumping right in, but what about an 'old-style'
> partition table that relies on 512 as a unit?
>
>   
I think that the normal case would involve new drives which would need 
to be partitioned in 4k aligned partitions. Shouldn't that work 
regardless of the unit used in the partition table?


ric



