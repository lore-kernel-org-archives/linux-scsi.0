From: Brad Campbell <brad@wasp.net.au>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 21:50:17 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <412E22D9.2060000@wasp.net.au>
References: <412DFFA9.8030504@wasp.net.au> <8746466a0408260852205a7842@mail.gmail.com> <412E1039.7030508@pobox.com> <412E135B.1030605@wasp.net.au> <412E1D3E.2050307@pobox.com> <8746466a04082610346b07ea11@mail.gmail.com> <412E2190.7030504@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <412E2190.7030504@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Dave <dave.jiang@gmail.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Dave wrote:
> 
>> On Thu, 26 Aug 2004 13:26:22 -0400, Jeff Garzik <jgarzik@pobox.com> 
>> wrote:
>>
>>> We could always eliminate lba48 max-sectors increase on VIA 
>>> controllers...
> 
> 
>> Has Brad tried it with native SATA drives instead of bridges? Could be
>> VIA controllers incompatible with PATA->SATA bridges.....
> 
> 
> 
> Oh wait.  That's a damned good point.
> 
> I wonder if there is a problem with LBA48 large transfers (>256 sectors) 
> and bridges.  Is Brad definitely using a bridge?  I may have missed that 
> detail in a flurry of emails :)

Yep.. using a bridge!
How to detect the bridge though?
