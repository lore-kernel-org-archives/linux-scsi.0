From: Ric Wheeler <ric@emc.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Sun, 11 Mar 2007 22:41:59 -0400
Message-ID: <45F4BDF7.1080001@emc.com>
References: <45F48809.2060908@emc.com> <20070312000253.20eab1a3@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070312000253.20eab1a3@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Alan Cox wrote:
>> Are there other concerns in the IO or FS stack that we should bring up 
>> with vendors?  I have been asked to summarize the impact of 4k sectors 
>> on linux  for a disk vendor gathering and want to make sure that I put 
>> all of our linux specific items into that summary...
>>     
>
> We need to make sure the physical sector size is correctly reported by
> the disk (eg in the ATA7 identify data) but I think for libata at least
> the right bits are already there and we've got a fair amount of scsi disk
> experience with other media sizes (eg 2K) already. 256byte/sector media
> is still broken btw 8)
>   
It would be really interesting to see if we can validate this with 
prototype drives.
> I would be interested to know what the disk vendors intend to use as
> their strategy when (with ATA) they have a 512 byte write from an older
> file system/setup into a 4K block. The case where errors magically appear
> in other parts of the fs when such an error occurs are not IMHO too well
> considered.
>
> Alan
As Jeff mentioned, I think that they would have to do a 
read-modify-write simulation which would kill performance for a small, 
random write work load...

ric

