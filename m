From: Brad Campbell <brad@wasp.net.au>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 21:37:00 +0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <412E1FBC.8000107@wasp.net.au>
References: <412DFFA9.8030504@wasp.net.au> <8746466a0408260852205a7842@mail.gmail.com> <412E1039.7030508@pobox.com> <412E135B.1030605@wasp.net.au> <412E1D3E.2050307@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <412E1D3E.2050307@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Dave <dave.jiang@gmail.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Brad Campbell wrote:
> 
>> In which case, these drives need to be knocked back to UDMA66 to 
>> function properly on anything later than 2.6.6. Don't know why.
>> I have tried multiple drives (I have 5 of them), multiple cables (lots 
>> of those) and multiple bridge boards (I have 6 of those). There is no 
>> combination that is reliable on the VIA controller with any transfer 
>> larger than about 0x80 sectors *OR* speeds greater than UDMA66 *OR* 
>> Kernel 2.6.6 or prior.
> 
> 
> 
> We could always eliminate lba48 max-sectors increase on VIA controllers...

Possibly, however I purchased a couple of new Maxtor Maxline-II SATA drives today and they play 
nicely with the VIA controller. It really appears to be a quirk of the WD Drive with the Addonics 
Bridge board.
I'll apply a patch locally I think rather than cripple every one using a VIA controller.
Either that or I can produce a patch along the lines of the sil quirk patch that looks for the 
WD2000JB (which is not a SATA model) and does it that way.
You never know, perhaps someone else out there might have the same combo of hardware some day.

Regards,
Brad
