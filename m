From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 10:22:04 -0500
Message-ID: <45C0B41C.4030608@rtr.ca>
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>	 <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com>	 <45BFF3D6.9050605@rtr.ca>  <45C00AEE.1090708@emc.com> <1170217288.10890.37.camel@mulgrave.il.steeleye.com> <45C0B211.2030305@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030181AbXAaPWK@vger.kernel.org>
In-Reply-To: <45C0B211.2030305@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <ric@emc.com>, "Eric D. Mudama" <edmudama@gmail.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
> James Bottomley wrote:
>>
>> For the MD case, this is what REQ_FAILFAST is for.
> 
> I cannot find where SCSI honours that flag.  James?

Scratch that thought.. SCSI honours it in scsi_end_request().

But I'm not certain that the block layer handles it correctly,
at least not in the 2.6.16/2.6.18 kernel that I'm working with today.

Cheers
