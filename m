From: Ric Wheeler <ric@emc.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Sun, 11 Mar 2007 22:37:04 -0400
Message-ID: <45F4BCD0.3040601@emc.com>
References: <45F48809.2060908@emc.com> <20070312000253.20eab1a3@lxorguk.ukuu.org.uk> <45F4A268.3000405@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45F4A268.3000405@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



Jeff Garzik wrote:
> Alan Cox wrote:
>> I would be interested to know what the disk vendors intend to use as
>> their strategy when (with ATA) they have a 512 byte write from an older
>> file system/setup into a 4K block. The case where errors magically 
>> appear
>
> Well, you have logical and physical sector size changes.
>
> First generation of 1K sector drives will continue to use the same 
> 512-byte ATA sector size you are familiar with.  A single 512-byte 
> write will cause the drive to perform a read-modify-write cycle.  This 
> configuration is physical 1K sector, logical 512b sector.
It would seem that most writes would avoid this - hopefully the drive 
firmware could use the write cache to coalesce contiguous IO's into 1k 
multiples when getting streams of 512 byte write requests.
>
> A future configuration will change the logical ATA interface away from 
> 512-byte sectors to 1K or 4K.  Here, it is impossible to read a 
> quantity smaller than 1K or 4K, whatever the sector size is.
>
>     Jeff
I will try and see if I can get some specific information on when the 
various flavors of this are going to appear...

ric

