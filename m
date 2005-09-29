From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 21:09:11 +0200
Message-ID: <433C3BD7.4090104@s5r6.in-berlin.de>
References: <Pine.LNX.4.10.10509281530190.19896-100000@master.linux-ide.org> <433C0285.3050106@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:29922 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932222AbVI2TLA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 15:11:00 -0400
In-Reply-To: <433C0285.3050106@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Andre Hedrick <andre@linux-ide.org>, Patrick Mansfield <patmans@us.ibm.com>, Luben Tuikov <ltuikov@yahoo.com>, Jeff Garzik <jgarzik@pobox.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

Luben Tuikov wrote:
> On 09/28/05 18:43, Andre Hedrick wrote:
>>Have you and company considered the approach of mapping to a library of
>>sorts?
> 
> Hmm, it is not a library.
> 
> It is a layer, again, because of what the chip actually is, and because
> of what it implements.
> 
> Take a look at the announcement text, I do give some description there
> and in the code the drivers/scsi/sas-class/README file describes
> the event/managment infrastructure.  Also you can take a look at the code.
> http://linux.adaptec.com/sas/
> 
> What you'll see in the code is:
> 
>   hardware implementation  (interconnect, SAM 4.15, 1.3)
>       firmware implementation  (interconnect, SDS, SAM 4.6, 1.3)
>           LLDD                     (SAM, section 5, 6, 7)
>              Transport Layer          (SAM 4.15, SAS)
>                   SCSI Core             (SAM section 4,5,8)
>                      Commmand Sets        (SAM section 1)
> 
> A very nice explanation in latest SAM4r03,
> section 4.15 The SCSI model for distributed communications.

BTW, Linux' implementations of transports like USB storage and SBP-2 
have always been similarly layered. (Actually they come with at least 
one more layer between LLDD and SCSI core.) Needless to say that these 
transports need their specific managing infrastructures. So this 
layering is not at all new to Linux.

> Now for MPT based solutions you have:
> 
>   LLDD                  (SAM, section 5, 6, 7)
>      SCSI Core             (SAM section 4,5,8)
>         Commmand Sets         (SAM section 1)
> 
> You see?  No Transport Layer between LLDD and SCSI Core!
> Why?  Because all this work is done in FIRMWARE!

-- 
Stefan Richter
-=====-=-=-= =--= ===-=
http://arcgraph.de/sr/
