From: Cameron Harr <charr@fusionio.com>
Subject: Re: [ofa-general] iSer and Direct IO
Date: Thu, 15 May 2008 09:50:28 -0600
Message-ID: <482C5BC4.6090301@fusionio.com>
References: <482B7FE4.9070502@fusionio.com>	<694d48600805150423n1a8b0efwf6d6596f8e7891ef@mail.gmail.com> <482C5293.5090005@fusionio.com> <482C55E2.8060905@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from slc.fusionio.com ([70.102.37.203]:61557 "EHLO mail.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533AbYEOPva (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 11:51:30 -0400
In-Reply-To: <482C55E2.8060905@scalableinformatics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: landman@scalableinformatics.com
Cc: general@lists.openfabrics.org, linux-scsi <linux-scsi@vger.kernel.org>

Joe Landman wrote:
> This is only 8 GB of IO.  It is possible that (despite dio) you are 
> caching.  Make the IO much larger than RAM.  Use a count of 128m or so.

This is going to sound dumb, but I thought I had 4 GB of RAM and thus 
intentionally used a file size 2x my physical RAM. As it turns out, I 
have 32GB of RAM on the box (4G usually shows up as 38.... and I just 
saw the 3). Anyway, with a 64GB file the numbers are looking more 
accurate (and even low):
393.3 MB/s
> We have found dd to be quite trustworthy with [oi]flag=direct.
I like it too. At any rate, I'm going to need to do some new testing to 
avoid the ram size (might just set a mem limit on the boot line).

There's still a bit of a discrepancy between IOP performance with iSer 
and srpt. Has anyone else done comparisons with the two? I think Erez 
was hoping to get some numbers before too long.
Cameron
