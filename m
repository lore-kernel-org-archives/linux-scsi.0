From: Reuben Farrelly <reuben-lkml@reub.net>
Subject: Re: 2.6.17-mm5 dislikes raid-1, just like mm4
Date: Sun, 02 Jul 2006 16:43:56 +1200
Message-ID: <44A74F0C.6040904@reub.net>
References: <20060701033524.3c478698.akpm@osdl.org>	<20060701181455.GA16412@aitel.hist.no> <20060701152258.bea091a6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tornado.reub.net ([202.89.145.182]:33492 "EHLO tornado.reub.net")
	by vger.kernel.org with ESMTP id S1751248AbWGBEnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jul 2006 00:43:55 -0400
In-Reply-To: <20060701152258.bea091a6.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Neil Brown <neilb@suse.de>, Grant Wilson <grant.wilson@zen.co.uk>



On 2/07/2006 10:22 a.m., Andrew Morton wrote:
> On Sat, 1 Jul 2006 20:14:55 +0200
> Helge Hafting <helgehaf@aitel.hist.no> wrote:
> 
>> I  just got mm5 up, and it has the same problem as mm4.
>> Raid-1 does not work. I used 2.6.16 to resync my raids,
>> and booted into 2.6.17-mm5.
<snip>
>> As we see, the md devices are assembled, then the filesystems are
>> mounted and swap turned on.  Then all three md devices fail a 
>> partition at the same time.  Somehow, I don't believe that
>> is correct. ;-)
>>
> 
> I assume this is still the broken-barriers bug.  Thanks for all the help on
> this, guys.  More is to be asked for, I'm afraid.
> 
> I've prepared a tree which is basically 2.6.17-mm5, only the git-scsi-misc
> and git-libata-all trees have been omitted.  It's at 
> 
> http://www.zip.com.au/~akpm/linux/patches/stuff/2.6.17-mm5-no-sata-scsi.bz2
> 
> (That's a diff against 2.6.17)

Works.

> If that kernel works, then the next step is to test
> 
> http://www.zip.com.au/~akpm/linux/patches/stuff/2.6.17-mm5-no-scsi.bz2
> 
> which is 2.6.17-mm5 without git-scsi-misc, but with git-libata-all.

Works.  I'm running it now and it looks to be all fine (including the 
workaround/fix for MSI)

In both cases I rebooted twice with each kernel to be sure it wasn't a one-off.

This then must point to git-scsi-misc being implicated, if not the source.......

Reuben
