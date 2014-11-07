From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] block: Introduce blkdev_issue_zeroout_discard() function
Date: Fri, 07 Nov 2014 10:42:24 -0500
Message-ID: <yq1k3379fvj.fsf@sermon.lab.mkp.net>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
	<1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
	<20141107082610.GC8394@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45948 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaKGPmx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 10:42:53 -0500
In-Reply-To: <20141107082610.GC8394@infradead.org> (Christoph Hellwig's
	message of "Fri, 7 Nov 2014 00:26:10 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de, Theodore Ts'o <tytso@mit.edu>

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> I'm not a fan of adding another function here and would
Christoph> prefer a flag, but it looks correct, 

That was my original approach too but I didn't want to stomp over all
the existing callers. Although there only are few.

Ted: Which would you prefer?

-- 
Martin K. Petersen	Oracle Linux Engineering
