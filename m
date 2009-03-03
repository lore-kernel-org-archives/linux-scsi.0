From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
 scsi-sgpool)objects
Date: Tue, 3 Mar 2009 23:22:16 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903032321230.11246@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>  <49ACF8FE.2020904@panasas.com>  <1236093718.3263.3.camel@localhost.localdomain>  <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain>
 <alpine.LFD.2.00.0903031818230.29264@localhost.localdomain> <alpine.LFD.2.00.0903032247170.29264@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36770 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762884AbZCCWWT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 17:22:19 -0500
In-Reply-To: <alpine.LFD.2.00.0903032247170.29264@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>


On Tuesday 2009-03-03 23:07, Thomas Gleixner wrote:

>On Tue, 3 Mar 2009, Thomas Gleixner wrote:
>> My bad. I was playing with that to get rid of the aic7xxx wreckage on
>> one of my test boxen and forgot to remove it.
>
>While the one below is definitey not my fault. It's on Linus latest:
>
> commit 2450cf51a1bdba7037e91b1bcc494b01c58aaf66

That commit seems to have nothing to do with filesystems or scsi:

commit 2450cf51a1bdba7037e91b1bcc494b01c58aaf66
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Mar 2 16:23:33 2009 -0800

    Revert "menu: fix embedded menu snafu"

?

>While compiling a kernel I triggerred the BUG below. Not so nice as it
>took a whole filesystem with it. fsck took more than 20 min to recover
>the leftovers :(

Stop using ext3 ;-)
