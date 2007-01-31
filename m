From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 15:23:01 +0000
Message-ID: <20070131152301.19a8a5ac@localhost.localdomain>
References: <200701301947.08478.liml@rtr.ca>
	<1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	<311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>
	<45BFF3D6.9050605@rtr.ca>
	<45C00AEE.1090708@emc.com>
	<45C0B0DC.8030501@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C0B0DC.8030501@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Ric Wheeler <ric@emc.com>, "Eric D. Mudama" <edmudama@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org

> When libata reports a MEDIUM_ERROR to us, we *know* it's non-recoverable,
> as the drive itself has already done internal retries (libata uses the
> "with retry" ATA opcodes for this).

This depends on the firmware. Some of the "raid firmware" drives don't
appear to do retries in firmware.

> But meanwhile, we still have the original issue too, where a single stray
> bad sector can blow a system out of the water, because the mid-layer
> currently aborts everything after it from a large merged request.
> 
> Thus the original patch from this thread.  :)

Agreed
