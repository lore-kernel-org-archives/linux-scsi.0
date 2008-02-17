From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] 2.6.25-rc1-git2: GDT SCSI: change drivers/scsi/gdth.c
 into using pci_get device
Date: Sun, 17 Feb 2008 11:42:36 -0500
Message-ID: <47B863FC.90500@garzik.org>
References: <47B1ADCE.40202@larces.uece.br> <1202833354.3137.19.camel@localhost.localdomain> <47B1CF45.5070407@panasas.com> <47B23033.1080100@larces.uece.br> <1202861823.3137.170.camel@localhost.localdomain> <47B2B101.3090106@panasas.com> <20080216163756.GG7657@parisc-linux.org> <47B80E65.7090504@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39948 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYBQQnU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Feb 2008 11:43:20 -0500
In-Reply-To: <47B80E65.7090504@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, support@adaptec.com, James Bottomley <James.Bottomley@HansenPartnership.com>, Sergio Luis <sergio@larces.uece.br>, Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>achim_leubner@adaptec.com

Boaz Harrosh wrote:
> On Sat, Feb 16 2008 at 18:37 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
>> On Wed, Feb 13, 2008 at 10:57:37AM +0200, Boaz Harrosh wrote:
>>> I still don't have a card for testing myself. Again anyone
>>> wants to send me a card. Intel people anybody home?
>> Apparently Intel sold this line of cards to Adaptec.  The copyright
>> notice in the file backs this up:
>>
>>  * Copyright (C) 1995-06 ICP vortex GmbH, Achim Leubner                 *
>>  * Copyright (C) 2002-04 Intel Corporation                              *
>>  * Copyright (C) 2003-06 Adaptec Inc.                                   *
>>  * <achim_leubner@adaptec.com>                                          *
>>
> 
> OK I never got this guy to ping back. CCing support@adaptec.com.
> 
> Who is the right contact person, regarding the HW that is supported
> by the gdth driver? Form what we see in driver commit logs (above), 
> it was transfered to  Adaptec from Intel in 2003. Is that still so?

In my experience Achim does respond, but this driver is probably very 
low priority, so it might take a while...

	Jeff




