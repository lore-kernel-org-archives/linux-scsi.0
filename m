From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Wed, 22 Apr 2009 19:27:25 +0000
Message-ID: <1240428445.3431.22.camel@mulgrave.int.hansenpartnership.com>
References: <20090422090929.GA14928@havoc.gtf.org>
	 <49EEE225.3010700@garzik.org> <49EF0A92.1070400@panasas.com>
	 <49EF337F.1030804@ngrt.de>  <20090422161856.1251f8a0@lxorguk.ukuu.org.uk>
	 <1240414622.3431.14.camel@mulgrave.int.hansenpartnership.com>
	 <49EF63A6.8040103@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755830AbZDVT1m@vger.kernel.org>
In-Reply-To: <49EF63A6.8040103@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniela Engert <dani@ngrt.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-04-22 at 14:36 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > On Wed, 2009-04-22 at 16:18 +0100, Alan Cox wrote:
> >>> Don't forget, there are ATAPI devices (some Sony CD burners and old 
> >>> phase-changers come into mind) which *do* have multiple LUNs sitting 
> >>> beyond the PATA port. I don't know if libata supports such setups (my 
> >>> old OS/2 driver does) but one shouldn't hijack LUNs to emulate targets.
> >> It's a long time ago since I tested it but my 5 CD changer was correctly
> >> supported by libata (or more accurately by sr...).
> > 
> > Well, sr supports the discovered CD/DVD; ch is the actual changer
> > manager.  Usually ch attaches to one LUN and sr attaches to another.
> 
> Like Alan's, if I understand him correctly, my PATA ATAPI CD changer 
> simply presents a bunch of addressible LUNs.  I never loaded, nor seemed 
> to need, ch.

Yes, they both seem to be non standard changer implementations that just
present as many CDs as they could chage to.

The ch is actually a driver for devices which conform to the SCSI Media
Changer standard, which tends to present  LUN zero as the smc device and
LUN1 as the selected CD/DVD

> I should boot a current libata and see how it behaves...

Might be fun.

James
