From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: (unknown)
Date: Fri, 10 Sep 2010 01:18:43 -0400
Message-ID: <1284095925-12841-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:17235 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab0IJFUE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 01:20:04 -0400
Subject: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, christof.schmitt@de.ibm.com
Cc: linux-scsi@vger.kernel.org


First patch moves min_not_zero() to kernel.h.  It's currently defined
several places throughout the block layer and I was about to introduce
another instance.  So let's make this generic.

Second patch works around the limitations in the zfcp hardware by
introducing a limit on the number of integrity scatterlist elements.
Christof will post a separate patch that updates the zfcp driver to take
advantage of this.

I'd prefer we if could feed everything, including the SCSI changes,
through the block tree.  I have had to change some existing interfaces
so a post-merge tree will not cut it and compatibility wrappers seem
like an overkill for this.

-- 
Martin K. Petersen	Oracle Linux Engineering


