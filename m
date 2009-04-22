From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Wed, 22 Apr 2009 17:27:10 +0100
Message-ID: <20090422172710.0d9fcc6c@lxorguk.ukuu.org.uk>
References: <20090422090929.GA14928@havoc.gtf.org>
	<49EEE225.3010700@garzik.org>
	<49EF0A92.1070400@panasas.com>
	<49EF337F.1030804@ngrt.de>
	<20090422161856.1251f8a0@lxorguk.ukuu.org.uk>
	<1240414622.3431.14.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1240414622.3431.14.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Daniela Engert <dani@ngrt.de>, Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

> > It's a long time ago since I tested it but my 5 CD changer was correctly
> > supported by libata (or more accurately by sr...).
> 
> Well, sr supports the discovered CD/DVD; ch is the actual changer
> manager.  Usually ch attaches to one LUN and sr attaches to another.

I get 5 LUNS and the hardware looks after the rest - no changer manager
needed. Early versions of the gnome folks CD probing stuff did give it a
bit of a fit as the firmware clearly didn't cache all the state that the
cd mangler asked for.

