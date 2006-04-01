From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] move ->eh_strategy_handler to the transport class
Date: Sat, 01 Apr 2006 13:23:57 -0600
Message-ID: <1143919437.3368.12.camel@mulgrave.il.steeleye.com>
References: <20060401172104.GA16921@lst.de>  <442EC214.1040303@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <442EC214.1040303@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@lst.de>, jejb@SteelEye.com, linux-scsi@vger.kernel.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2006-04-01 at 13:10 -0500, Jeff Garzik wrote:
> I would prefer to merge it through the libata-dev queue, since -- as a 
> glance through the recent kernel changelog shows -- Tejun Heo has been 
> ripping through this part of libata as well.

I'm afraid we can't do that since we have the sas class to convert as
well ... what I could do is take it through a separate tree and pull
that into scsi-misc and you can pull it into libata.  That will
(hopefully) ensure we both get it right.

James


