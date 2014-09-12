From: Jens Axboe <axboe@fb.com>
Subject: Re: Block/SCSI data integrity update v3
Date: Fri, 12 Sep 2014 12:16:46 -0600
Message-ID: <5413388E.90901@fb.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>	<53FF8CC9.9030206@fb.com> <20140907162957.GA17353@infradead.org>	<540DD05B.7030908@fb.com> <yq1tx4f80ph.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65469 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751413AbaILSRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 14:17:10 -0400
In-Reply-To: <yq1tx4f80ph.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, hch@lst.de, sagig@mellanox.com

On 09/10/2014 06:23 PM, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <axboe@fb.com> writes:
> 
> Jens> Thanks, I'll do that once Martin respins the previous series (was
> Jens> pulled due to multiple issues).
> 
> I bumped bi_rw to u64 as discussed. Will get that into -next to see if
> there's any fallout.

Don't push it into -next, start with having it in a branch somewhere
where Wu's automagic robots will pick it up. If they don't already,
email Wu and get that done!


-- 
Jens Axboe

