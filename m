From: Brad Campbell <brad@wasp.net.au>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 20:44:11 +0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <412E135B.1030605@wasp.net.au>
References: <412DFFA9.8030504@wasp.net.au> <8746466a0408260852205a7842@mail.gmail.com> <412E1039.7030508@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <412E1039.7030508@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Dave <dave.jiang@gmail.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Dave wrote:
> 
>> I believe. I wish the SATA layer would allow a mechanism to auto
>> detect drive being LBA48 or LBA28 and adjust accordingly instead of
>> just default to a very low sector count.
> 
> 
> 
> The SATA layer already does this...  but only on 2.6.x kernels.
> 
> drivers/scsi/libata-scsi.c, ata_scsi_slave_config()
> 

(Groan) <Places head in hands weeping>

I give up Batman.

In which case, these drives need to be knocked back to UDMA66 to function properly on anything later 
than 2.6.6. Don't know why.
I have tried multiple drives (I have 5 of them), multiple cables (lots of those) and multiple bridge 
boards (I have 6 of those). There is no combination that is reliable on the VIA controller with any 
transfer larger than about 0x80 sectors *OR* speeds greater than UDMA66 *OR* Kernel 2.6.6 or prior.



Regards,
Brad
