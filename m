From: Reuben Farrelly <reuben-lkml@reub.net>
Subject: Re: 2.6.17-mm5 dislikes raid-1, just like mm4
Date: Sun, 02 Jul 2006 17:13:47 +1200
Message-ID: <44A7560B.3050000@reub.net>
References: <20060701033524.3c478698.akpm@osdl.org>	<20060701181455.GA16412@aitel.hist.no> <20060701152258.bea091a6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tornado.reub.net ([202.89.145.182]:61396 "EHLO tornado.reub.net")
	by vger.kernel.org with ESMTP id S932120AbWGBFNp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jul 2006 01:13:45 -0400
In-Reply-To: <20060701152258.bea091a6.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Neil Brown <neilb@suse.de>, Grant Wilson <grant.wilson@zen.co.uk>


On 2/07/2006 10:22 a.m., Andrew Morton wrote:
> I assume this is still the broken-barriers bug.  Thanks for all the help on
> this, guys.  More is to be asked for, I'm afraid.
> 
> I've prepared a tree which is basically 2.6.17-mm5, only the git-scsi-misc
> and git-libata-all trees have been omitted.  It's at 
> 
> http://www.zip.com.au/~akpm/linux/patches/stuff/2.6.17-mm5-no-sata-scsi.bz2
> 
> (That's a diff against 2.6.17)
> 
> If that kernel works, then the next step is to test
> 
> http://www.zip.com.au/~akpm/linux/patches/stuff/2.6.17-mm5-no-scsi.bz2
> 
> which is 2.6.17-mm5 without git-scsi-misc, but with git-libata-all.

Just for kicks, after testing those two trees (see previous email) I took my 
2.6.17-mm5 without git-scsi-misc and then patched git-scsi-misc.patch back in, 
rebuilt and rebooted and noted that RAID broke again.  Reverted the patch and it 
all worked.

So I can conclude that definitely and reproduceably that's the one.........

reuben


