From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: block: don't check request size in blk_cloned_rq_check_limits()
Date: Tue, 14 Jun 2016 22:32:30 -0400
Message-ID: <yq137ofb2rl.fsf@sermon.lab.mkp.net>
References: <1464593093-93527-1-git-send-email-hare@suse.de>
	<20160610131901.GA28570@redhat.com>
	<yq160tgfoqr.fsf@sermon.lab.mkp.net> <575BE182.5010304@suse.de>
	<yq11t44f0hi.fsf@sermon.lab.mkp.net> <575C0DAE.7070502@suse.de>
	<yq17fdrcjs3.fsf@sermon.lab.mkp.net>
	<20160615022903.GB5443@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34376 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbcFOCco (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 22:32:44 -0400
In-Reply-To: <20160615022903.GB5443@redhat.com> (Mike Snitzer's message of
	"Tue, 14 Jun 2016 22:29:03 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, mark.bergman@uphs.upenn.edu

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> Oh, this happens during failover? Are you sure it's not because DM is
>> temporarily resetting the queue limits? max_sectors is going to be a
>> single page in that case. I just discussed a backport regression in
>> this department with Mike at LSF/MM. But that was for an older
>> kernel.

Mike> Not aware of any limits reset issue now...

Me neither, I was assuming that Hannes is seeing this with SLES.

-- 
Martin K. Petersen	Oracle Linux Engineering
