From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: 12 Oct 2004 12:09:55 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1097601002.1763.84.camel@mulgrave>
References: <4165A85D.7080704@rtr.ca> <4165AB1B.8000204@pobox.com>
	<4165ACF8.8060208@rtr.ca> <20041007221537.A17712@infradead.org>
	<1097241583.2412.15.camel@mulgrave> <4166AF2F.6070904@rtr.ca>
	<1097249266.1678.40.camel@mulgrave> <4166B37D.8030701@rtr.ca>
	<1097251299.1928.56.camel@mulgrave> <416C0DC5.2080206@rtr.ca>
	<20041012170526.GB9274@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S266465AbUJLROQ@vger.kernel.org>
In-Reply-To: <20041012170526.GB9274@havoc.gtf.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lkml@rtr.ca>, Christoph Hellwig <hch@infradead.org>, Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2004-10-12 at 12:05, Jeff Garzik wrote:
> I'll respectfully disagree with James...  I think the most prudent
> course of action is to follow the example of SCSI common code.
> 
> If the SCSI core is doing something wrong, we should fix that _first_,
> not set a precedent of confusing dissociation.
> 
> Everyone knows that Linux programmers engineer with their cut-n-paste
> feature.

So you'll be sending me the patches that do this?

James
