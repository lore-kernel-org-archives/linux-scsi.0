From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: RFC: moving drivers to a new drivers/ata directory
Date: Fri, 15 Oct 2004 13:20:48 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <417006F0.5040706@pobox.com>
References: <416F5757.8000306@pobox.com> <416F8C39.6010804@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <416F8C39.6010804@torque.net>
To: dougg@torque.net
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Jeff Garzik wrote:
> 
>>
>> Eventually I would like to move libata, and a few non-libata driver 
>> like 3ware, to drivers/ata.  It would appear in the makefile (and link 
>> order) _after_ drivers/ide and drivers/scsi.
>>
>> Comments/objections?
> 
> 
> A comment: if SAS HBAs ever get installed on motherboards then
> it won't be obvious to the average user which susbsystem they
> should configure (i.e. ATA/SATA or SCSI/SAS). In both cases an
> internal SATA disk could be connected via a SATA cable to a
> plug on the motherboard.
> 
> So if you do move the drivers to the ata directory it may be
> useful to stress that it is the category of HBA that is
> signficant rather than the device at the far end of the cable.


That implies that scsi is an acceptable appelation for ATA controllers?

Maybe we need a neutral one like 'drivers/storage'.

	Jeff


