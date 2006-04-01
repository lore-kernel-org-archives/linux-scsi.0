From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] move ->eh_strategy_handler to the transport class
Date: Sat, 01 Apr 2006 14:27:30 -0500
Message-ID: <442ED422.4080603@garzik.org>
References: <20060401172104.GA16921@lst.de>  <442EC214.1040303@garzik.org> <1143919437.3368.12.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1143919437.3368.12.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@SteelEye.com, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sat, 2006-04-01 at 13:10 -0500, Jeff Garzik wrote:
>> I would prefer to merge it through the libata-dev queue, since -- as a 
>> glance through the recent kernel changelog shows -- Tejun Heo has been 
>> ripping through this part of libata as well.
> 
> I'm afraid we can't do that since we have the sas class to convert as
> well ... what I could do is take it through a separate tree and pull
> that into scsi-misc and you can pull it into libata.  That will
> (hopefully) ensure we both get it right.

Works for me...

Thanks,

	Jeff



