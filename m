From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: RFC: moving drivers to a new drivers/ata directory
Date: Wed, 20 Oct 2004 11:46:05 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <4176883D.7070905@pobox.com>
References: <416F5757.8000306@pobox.com> <20041015074627.GA18977@infradead.org> <41700747.6040506@pobox.com> <20041020153444.GA21881@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20041020153444.GA21881@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Oct 15, 2004 at 01:22:15PM -0400, Jeff Garzik wrote:
> 
>>Welcome to the real world, where SCSI drivers can be for non-SCSI 
>>hardware, and where SCSI hardware can also drive non-SCSI devices.
>>
>>Fix your subsystem, if it can't support SCSI drivers outside of 
>>drivers/scsi.
> 
> 
> It's not about not working but making life for the scsi maintainers easier.


SCSI drivers outside drivers/scsi are going to continue to be a fact of 
life...  And if that is the case there shouldn't be much of a 
demonstrable difference between drivers/scsi... except for the obvious 
times when drivers/scsi is used but is inappropriate.

	Jeff

