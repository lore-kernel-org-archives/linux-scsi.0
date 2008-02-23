From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PATCH] scsi fixes for 2.6.25-rc2
Date: Sat, 23 Feb 2008 15:25:24 -0500
Message-ID: <47C08134.2030205@garzik.org>
References: <1203779614.3139.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35975 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677AbYBWUZ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Feb 2008 15:25:28 -0500
In-Reply-To: <1203779614.3139.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> This is the latest crop of bug fixes plus one new driver: mvsas.  We're
[...]
> Jeff Garzik (1):
>       mvsas: Add Marvell 6440 SAS/SATA driver
[...]
> Ke Wei (1):
>       mvsas: convert from rough draft to working driver


I know I am probably shooting myself in the foot here, since I am the 
original author of mvsas, but...

Should we be adding new drivers during -rc?

On one hand, it's clear the addition does not break anything, and adds 
value for users.

On the other hand, it's clearly not a bug fix, and -rc could easily get 
bloated with new drivers that didn't make the merge window.

On the net driver side of things, I have a few new net drivers that I 
have queued for 2.6.26, because they did not make the merge window. 
This is inconsistent with your apparently policy.

I would just prefer to have a clear and consistent policy here, 
regarding new drivers during -rc.

Thanks,

	Jeff


