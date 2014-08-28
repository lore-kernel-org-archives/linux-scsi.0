From: Jens Axboe <axboe@fb.com>
Subject: Re: Block/SCSI data integrity update v3
Date: Thu, 28 Aug 2014 14:10:49 -0600
Message-ID: <53FF8CC9.9030206@fb.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40337 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892AbaH1UKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 16:10:55 -0400
In-Reply-To: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: hch@lst.de, sagig@mellanox.com

On 08/28/2014 01:31 PM, Martin K. Petersen wrote:
> This is the data integrity patch series originally submitted for 3.16
> and 3.17.  It has been rebased on top of block/for-3.18/core.  Other
> than that there are no changes from v2.

Thanks, picked up. I did not apply 14/14 since that should go through
the SCSI tree. I can carry it if need be, but it'd be nice to have a
SCSI signoff on it then.

-- 
Jens Axboe

