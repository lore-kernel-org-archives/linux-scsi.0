From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 10:13:21 -0500
Message-ID: <45C0B211.2030305@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>	 <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>	 <45BFF3D6.9050605@rtr.ca>  <45C00AEE.1090708@emc.com> <1170217288.10890.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1170217288.10890.37.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <ric@emc.com>, "Eric D. Mudama" <edmudama@gmail.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
>
> For the MD case, this is what REQ_FAILFAST is for.

I cannot find where SCSI honours that flag.  James?

And for that matter, even when I patch SCSI so that it *does* honour it,
I don't actually see the flag making it into the SCSI layer from above.

And I don't see where/how the block layer takes care when considering
merge FAILFAST/READA requests with non FAILFAST/READA requests.
To me, it looks perfectly happy to add non-FAILFAST/READA bios
to a FAILFAST request, risking data loss if a lower-layer decides
to honour the FAILFAST/READA flags.

So it's a pretty Good Thing(tm) that SCSI doesn't currently honour it. ;)
 

