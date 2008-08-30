From: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH] scsi/sd: Fix size output in MB
Date: Sat, 30 Aug 2008 23:24:29 +0100
Message-ID: <48B9C89D.7050800@simon.arlott.org.uk>
References: <48B9546B.4010004@simon.arlott.org.uk>	<1220117091.3615.3.camel@localhost.localdomain>	<20080830174516.GD1239@parisc-linux.org>	<20080830225950.4828dcf6@mjolnir.drzeus.cx>	<1220132749.3615.14.camel@localhost.localdomain> <20080831001314.694df795@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proxima.lp0.eu ([85.158.45.36]:49514 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbYH3WYe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Aug 2008 18:24:34 -0400
In-Reply-To: <20080831001314.694df795@mjolnir.drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 30/08/08 23:13, Pierre Ossman wrote:
> On Sat, 30 Aug 2008 16:45:49 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
>> On Sat, 2008-08-30 at 22:59 +0200, Pierre Ossman wrote:
>> > On Sat, 30 Aug 2008 11:45:16 -0600
>> > Matthew Wilcox <matthew@wil.cx> wrote:
>> > 
>> > > 
>> > > 2. We should report in GB or TB when appropriate.  The exact definition
>> > > of 'appropriate' is going to vary from person to person.  Might I
>> > > suggest that we should report between two and four significant digits.
>> > > eg 9543 MB is ok, 10543 MB should be 10 GB.
>> > > 
>> > 
>> > I've been looking at doing something like this for the mmc_block
>> > driver, so a generic helper is welcome. :)
>> 
>> Does MMC have the 10^3 requirement like SCSI/ATA disks do, or can you
>> use 2^10 like standard computer stuff for capacities?
>> 
> 
> Some do, some don't. I prefer the 2^10 and MiB variants as it avoids
> ambiguity.

If there's a generic function to do this, there could be a Kconfig option 
to select the variant (10^3 MB, 2^10 MiB, 2^10 MB ;)), as long as the byte 
value is available from the same message.

-- 
Simon Arlott
