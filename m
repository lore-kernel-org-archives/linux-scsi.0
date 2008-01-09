From: Jon Watte <jwatte@gmail.com>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 09 Jan 2008 12:36:26 -0800
Message-ID: <4785304A.60109@gmail.com>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.237]:53605 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbYAIUgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 15:36:31 -0500
Received: by nz-out-0506.google.com with SMTP id s18so205759nze.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jan 2008 12:36:31 -0800 (PST)
In-Reply-To: <4785138A.4000809@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Stefan Richter wrote:
>> Those systems (servers) typically have enough memory to tolerate a few
>> extra KB of code without problems.  In fact most PCs these days have.
>>     
>
> It would be a stupid solution nevertheless.
>
> (We also don't "select EXT3".)
>   

It's not the prettiest solution, but it would reduce the number of 
"support incidents." And, after all, reducing the number of support 
incidents is the goal of usability.

Not selecting EXT3 is a little more understandable, because there are 
many options -- cramfs, xfs, reiserfs, etc, depending on target. 
However, the number of people who DO want SATA support but DO NOT want 
SD block device support is... uh.. anyone?

Solving the problem bigger and better, by factoring "SD" into a 
mid-level menu, and maybe calling it something non-SCSI, would probably 
be even better. And even more work.

OK, I'll go hide now and try not to fan any flames. And thanks again to 
Andi for nailing my problem right away!

Cheers,

          / h+


