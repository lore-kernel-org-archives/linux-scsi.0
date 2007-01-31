From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 10:38:47 -0500
Message-ID: <45C0B807.8010508@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com> <45BFF3D6.9050605@rtr.ca> <45C061C3.8030006@garzik.org> <45C0A985.7010402@emc.com> <45C0B5A1.8000506@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932929AbXAaPiv@vger.kernel.org>
In-Reply-To: <45C0B5A1.8000506@torque.net>
Sender: linux-kernel-owner@vger.kernel.org
To: dougg@torque.net
Cc: ric@emc.com, Jeff Garzik <jeff@garzik.org>, "Eric D. Mudama" <edmudama@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
>
> Ric,
> Both ATA (ATA8-ACS) and SCSI (SBC-3) have recently added
> command support to flag a block as "uncorrectable". There
> is no need to send bad "long" data to it and suppress the
> disk's automatic re-allocation logic.

That'll be useful in a couple of years, once drives that have it
become more common.  For now, though, we're hacking current drives
using READ/WRITE LONG commands, with a corresponding patch to libata
to allow for the longer "sector size" involved.

Having real bad sectors, exactly where we want them on the media,
sure does make testing / fixing the EH mechanisms a lot more feasible.

Cheers
