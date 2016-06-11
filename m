From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Fri, 10 Jun 2016 22:22:52 -0400
Message-ID: <yq160tgfoqr.fsf@sermon.lab.mkp.net>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
	<20160610131901.GA28570@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48946 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbcFKCXF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2016 22:23:05 -0400
In-Reply-To: <20160610131901.GA28570@redhat.com> (Mike Snitzer's message of
	"Fri, 10 Jun 2016 09:19:01 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> When checking a cloned request there is no need to check the overall
>> request size; this won't have changed even when resubmitting to
>> another queue.  Without this patch ppc64le on ibmvfc fails to boot.

Why is the number of sectors in the request bigger than the queue limit?

-- 
Martin K. Petersen	Oracle Linux Engineering
