From: Grant Wilson <grant.wilson@zen.co.uk>
Subject: Re: 2.6.17-mm5 dislikes raid-1, just like mm4
Date: Sun, 02 Jul 2006 16:43:14 +0100
Message-ID: <44A7E992.4010201@zen.co.uk>
References: <20060701033524.3c478698.akpm@osdl.org>	 <20060701181455.GA16412@aitel.hist.no>	 <20060701152258.bea091a6.akpm@osdl.org>  <44A7560B.3050000@reub.net>	 <1151848394.3558.2.camel@mulgrave.il.steeleye.com>	 <44A7D82A.80909@zen.co.uk> <1151852788.3558.10.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pythagoras.zen.co.uk ([212.23.3.140]:32489 "EHLO
	pythagoras.zen.co.uk") by vger.kernel.org with ESMTP
	id S932386AbWGBPnW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jul 2006 11:43:22 -0400
In-Reply-To: <1151852788.3558.10.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Reuben Farrelly <reuben-lkml@reub.net>, Andrew Morton <akpm@osdl.org>, Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Neil Brown <neilb@suse.de>

James Bottomley wrote:
> On Sun, 2006-07-02 at 15:28 +0100, Grant Wilson wrote:
>> With the patch applied to 2.6.17-mm5 my RAID-1 is up and running on both
>> SATA drives with no problems.
> 
> That's great, thanks.  Now we know what the problem patch is, I'd like
> to try an 11th our correction of the logic fault in the original.  Could
> you try this patch against original -mm (by reversing the previous
> patch).  I think it should correct the problem?
> 
> Thanks,
> 
> James
> 
[snip]

With the first patch reversed and the second applied to -mm5 my RAID-1
array is still working correctly on both disks.

Thanks again,
Grant
