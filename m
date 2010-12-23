From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Boot failure with block/for-next
Date: Wed, 22 Dec 2010 22:31:13 -0600
Message-ID: <1293078673.3019.765.camel@mulgrave.site>
References: <1293038823.3019.89.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43795 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab0LWEbS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Dec 2010 23:31:18 -0500
In-Reply-To: <1293038823.3019.89.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <htejun@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 2010-12-22 at 11:27 -0600, James Bottomley wrote:
> Trying to test out the SCSI post merge tree, I've found it won't boot on
> my SCSI test system.  The reason is a failure to read the partition
> table of the root disc.  It just gives
> 
> sda: unable to read partition table
> 
> The other four discs in the system seem to read their partition tables
> OK.
> 
> The obvious candidate is the partition code rework in block/for-next.
> Simply reverting 

Actually, surprisingly, bisection confirms it's this patch:

Author: Tejun Heo <tj@kernel.org>
Date:   Wed Dec 8 20:57:42 2010 +0100

    sd: implement sd_check_events()

I can't quite see how yet.

James


