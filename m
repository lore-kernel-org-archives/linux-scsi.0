From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: RFC: moving drivers to a new drivers/ata directory
Date: Fri, 15 Oct 2004 13:22:15 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <41700747.6040506@pobox.com>
References: <416F5757.8000306@pobox.com> <20041015074627.GA18977@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20041015074627.GA18977@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Oct 15, 2004 at 12:51:35AM -0400, Jeff Garzik wrote:
> 
>>Eventually I would like to move libata, and a few non-libata driver like 
>>3ware, to drivers/ata.  It would appear in the makefile (and link order) 
>>_after_ drivers/ide and drivers/scsi.
>>
>>Comments/objections?
> 
> 
> Only if your stop using the scsi subsystem.  The handfull scsi drivers outside
> drivers/scsi are a pain already.

Welcome to the real world, where SCSI drivers can be for non-SCSI 
hardware, and where SCSI hardware can also drive non-SCSI devices.

Fix your subsystem, if it can't support SCSI drivers outside of 
drivers/scsi.

	Jeff



