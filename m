From: Jens Axboe <axboe@fb.com>
Subject: Re: Block/SCSI data integrity update v3
Date: Mon, 8 Sep 2014 09:50:51 -0600
Message-ID: <540DD05B.7030908@fb.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com> <53FF8CC9.9030206@fb.com> <20140907162957.GA17353@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18011 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752986AbaIHPvK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2014 11:51:10 -0400
In-Reply-To: <20140907162957.GA17353@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, hch@lst.de, sagig@mellanox.com

On 09/07/2014 10:29 AM, Christoph Hellwig wrote:
> On Thu, Aug 28, 2014 at 02:10:49PM -0600, Jens Axboe wrote:
>> On 08/28/2014 01:31 PM, Martin K. Petersen wrote:
>>> This is the data integrity patch series originally submitted for 3.16
>>> and 3.17.  It has been rebased on top of block/for-3.18/core.  Other
>>> than that there are no changes from v2.
>>
>> Thanks, picked up. I did not apply 14/14 since that should go through
>> the SCSI tree. I can carry it if need be, but it'd be nice to have a
>> SCSI signoff on it then.
> 
> While Sagi found some minor nitpicks I think we could address them later
> if needed, so
> 
> Acked-by: Christoph Hellwig <hch@lst.de>
> 
> from me for picking it up through the block tree.

Thanks, I'll do that once Martin respins the previous series (was pulled
due to multiple issues).

-- 
Jens Axboe

