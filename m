From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch resend] firewire: ieee1394: Move away from SG_ALL
Date: Wed, 06 Aug 2008 22:49:43 +0200
Message-ID: <489A0E67.3070909@s5r6.in-berlin.de>
References: <tkrat.768de7e4b028b713@s5r6.in-berlin.de>	<1217877676.3318.32.camel@localhost.localdomain>	<48975F5F.90906@s5r6.in-berlin.de>
	<489845FC.4080104@panasas.com>	<4898B0AF.6050800@s5r6.in-berlin.de>
	<48996A7D.3080101@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <48996A7D.3080101@panasas.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> You will need to enable sg chaining for your device.

Probably, because...

> I'm not sure where is the latest documentation. (CC: Jens)
> 
> Here is the script I used in my tests:
> 
> 	#!/bin/bash
> 	sdx=sdb
> 
> 	# mess with sglist chaining
> 	cd /sys/block/$sdx/queue
> 	echo 4096 > max_segments
> 	cat max_hw_sectors_kb  > max_sectors_kb
> 	echo "max_hw_sectors_kb="$(cat max_hw_sectors_kb) 
> 	echo "max_sectors_kb="$(cat max_sectors_kb) 
> 	echo "max_segments="$(cat max_segments)
> 
> Try to view the content of max_segments before and after
> see if it changed.

...right now there is no max_segments attribute.

Anyway.  This already fully answers what my ideal table size limit is. 
Thanks so far,
-- 
Stefan Richter
-=====-==--- =--- --==-
http://arcgraph.de/sr/

-------------------------------------------------------------------------
This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
Build the coolest Linux based applications with Moblin SDK & win great prizes
Grand prize is a trip for two to an Open Source event anywhere in the world
http://moblin-contest.org/redirect.php?banner_id=100&url=/
